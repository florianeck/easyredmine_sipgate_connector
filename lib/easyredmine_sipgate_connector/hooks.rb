module EasyredmineSipgateConnector
  class Hooks < Redmine::Hook::ViewListener
  
    def helper_user_settings_tabs(context = {})
      context[:tabs] << {:name => 'sipgate', :partial => 'sipgate_connector/user_settings', :label => :label_sipgate, :user => context[:user]}
    end
    
    def view_layouts_base_html_head(context = {})
      stylesheet_link_tag 'easyredmine_sipgate', :plugin => 'easyredmine_sipgate_connector'
    end
  end
end  