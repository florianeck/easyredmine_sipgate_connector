module EasyredmineSipgateConnector
  class Hooks < Redmine::Hook::ViewListener
  
    def helper_user_settings_tabs(context = {})
      context[:tabs] << {:name => 'sipgate', :partial => 'sipgate_connector/user_settings', :label => :label_sipgate, :user => context[:user]}
    end
  end
end  