class SipgateCallHistory < ActiveRecord::Base
  
  #= Model Description  (Replace with model name)
  #== Schema
  # integer   :user_id
  # integer   :easy_contact_id
  # string    :call_id          # => internal id from sipgate, must be unique
  # string    :source           # => source/caller phone number
  # string    :target           # => target/callee phone number
  # string    :source_alias     # => source/caller alias from adressbook if available
  # string    :target_alias     # => target/callee alias from adressbook if available
  # string    :call_type        # => CALL/VOICEMAIL
  # datetime  :call_created_at  # => Timestamp when call was started
  # string    :direction        # => INCOMING/OUTGOING
  # string    :transcription    # => Speech 2 Text for voicemail if available
  # string    :recording_url    # => URL of voicemail record if available
  # integer   :duration         # => call duration in seconds
  
  #== Configuration
  
  scope :without_easy_contact, -> { where(easy_contact_id: nil) }
  default_scope -> { order("call_created_at DESC") }
  
  #== Associations
  belongs_to :user
  belongs_to :easy_contact
  
  #== Plugins and modules
  #=== PlugIns
  #
  
  #=== include Modules
  #
  
  #== Konstanten
  #
  
  
  #== Validation
  validates_presence_of :user_id, :source, :target, :call_type, :direction, :duration, :call_created_at
  validates_uniqueness_of :call_id
  
  #== Callbacks
  before_save :assign_easy_contact, :set_external_and_private_flag
  after_save :set_easy_contact_issues_journal
  after_save :delete_history_from_sipgate_server, if: :sipgate_delete_after_fetch?
  
  def self.load_call_history_for_user(user)
    return if user.sipgate_token.nil?
    current_offset = 0
    found_existing = false
    page_size = EasyredmineSipgateConnector.history_page_size
    stored_call_ids = self.where(user_id: user.id).pluck(:call_id)
    current_history = user.rusip_api.history_for_user(user.sipgate_user_id, offset: current_offset, limit: page_size)['items']
    
    while (current_history.present? && current_history.size > 0) && found_existing == false
      current_history.each do |history_data|
        # skip database call for existing entries
        if stored_call_ids.include?(history_data['id'])
          found_existing = true
          break
        end
      
        history_entry = self.new(user_id: user.id)
        history_entry.assign_history_data(history_data)
        history_entry.save
      end
      current_offset += page_size
      current_history = nil
      
      while current_history.nil? && page_size > 1
        begin
          current_history = user.rusip_api.history_for_user(user.sipgate_user_id, offset: current_offset, limit: page_size)['items']  
        rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
          puts "Reducing page size because of #{e.name}"
          page_size = page_size/2
          sleep 3
        end
      end  
    end  
  end
  
  def status_label
    [
      I18n.t("activerecord.attributes.sipgate_call_history.call_types.#{self.call_type}"),
      I18n.t("activerecord.attributes.sipgate_call_history.directions.#{self.direction}")
    ].join(" - ")
  end
    
  def assign_history_data(data)
    self.call_id          = data['id']
    self.source           = data['source']
    self.target           = data['target']
    self.source_alias     = data['sourceAlias']
    self.target_alias     = data['targetAlias']
    self.call_type        = data['type']
    self.call_created_at  = data['created']
    self.direction        = data['direction']
    self.transcription    = data['transcription']
    self.recording_url    = data['recordingUrl']
    self.duration         = data['duration']
  end
  
  def assign_easy_contact
    return if self.easy_contact_id.present?
    query = "telephone_cached REGEXP '\\\\+17([[:>:]]|$)'".gsub("+17", self.external_caller[:nr])
    self.easy_contact = EasyContact.where(query).first
  end
  
  # nur calls
  # nur wenn dauer > 10
  # nur wenn call  nach erstellung des tickets
  
  def set_easy_contact_issues_journal
    if self.assignable_to_issue?
      issues = self.easy_contact.issues.open(true).where("created_on >= ?", self.call_created_at)
      issues.each do |issue|
        # skip if journal has been set
        next if issue.journals.where(sipgate_call_history_id: self.id).any? && Rails.env.production?
        
        Journal.create(
          journalized: issue,
          user_id: self.user_id,
          sipgate_call_history_id: self.id,
          notes: I18n.t(:journal_note_for_call, url: "#{EasyredmineSipgateConnector.config_from_yaml['redirect_host']}/easy_contacts/#{self.easy_contact_id}?call_id=#{self.id}", status_label: self.status_label, locale: (self.user.language.presence || I18n.default_locale)),
          created_on: self.call_created_at
        )
      end
    end  
  end
  
  def external_caller
    if self.direction.match(/OUT/)
      { nr: self.target, name: self.target_alias }
    else
      { nr: self.source, name: self.source_alias }
    end
  end
  
  def internal_caller
    if self.direction.match(/INCOMING/)
      { nr: self.target, name: self.target_alias }  
    else
      { nr: self.source, name: self.source_alias }      
    end
  end
  
  def set_external_and_private_flag
    self.external_number = external_caller[:nr]
    self.private_call = self.class.where(private_call: true, external_number: self.external_number).any?
    
    return true
  end
  
  def assignable_to_issue?
    self.easy_contact.present? && 
    self.duration >= EasyredmineSipgateConnector.min_call_duration_for_issue_assignment && 
    EasyredmineSipgateConnector.call_types_for_issue_assignment.include?(self.call_type)  
  end
  
  def sipgate_delete_after_fetch?
    self.user.try(:sipgate_delete_after_fetch?)
  end
  
  def delete_history_from_sipgate_server
    begin
      self.user.rusip_api.history_delete(self.user.sipgate_user_id, self.call_id)
    rescue Exception => e
      puts e.message
    end
  end
  
  
end