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
  
  
end