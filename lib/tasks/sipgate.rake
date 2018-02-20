namespace :sipgate do
  
  desc "Loads call histories for users with sipgate_user_id set"
  task :load_call_histories => :environment do
    User.where.not(sipgate_user_id: nil).each do |user|
      SipgateCallHistory.load_call_history_for_user(user)
    end
  end
  
  desc "Try to assign call histories to EasyContacts if not already set"
  task :assign_easy_contacts => :environment do
    SipgateCallHistory.without_easy_contact.each(&:save)
  end
  
  desc "Load and Assign call histories"
  task :sipgate_sync => :environment do
    User.where.not(sipgate_user_id: nil).each do |user|
      SipgateCallHistory.load_call_history_for_user(user)
    end
    SipgateCallHistory.without_easy_contact.each(&:save)
  end
  
  desc "Delete entire call history user given with USER_ID="
  task :delete_user_call_history do
    user = User.find(ENV['USER_ID'])
    
    return if user.sipgate_token.nil?
    current_offset = 0
    page_size = EasyredmineSipgateConnector.history_page_size
    current_history = user.rusip_api.history_for_user(user.sipgate_user_id, offset: current_offset, limit: page_size)['items']
    
    while (current_history.present? && current_history.size > 0)
      puts "Loading page #{current_offset+1}"
      puts "- found #{current_history.size} entries"
      current_history.each do |history_data|
        user.rusip_api.history_delete(user.sipgate_user_id, history_data['id'])
        puts "-- deleted entry #{history_data['id']}"
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
  
  
end