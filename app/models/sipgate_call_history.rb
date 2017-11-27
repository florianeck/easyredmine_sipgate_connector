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
  #
  
  def self.load_call_history_for_user(user)
    return if user.sipgate_token.nil?
    current_history = user.rusip_api.history_for_user(user.sipgate_user_id)['items']
    
    stored_call_ids = self.where(user_id: user.id).pluck(:call_id)
    current_history.each do |history_data|
      # skip database call for existing entries
      next if stored_call_ids.include?(history_data['id'].to_i)
      
      history_entry = self.new(user_id: user.id)
      history_entry.assign_history_data(history_data)
      history_entry.save
    end
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
  
  
end