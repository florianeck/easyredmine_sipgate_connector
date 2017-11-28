module EasyredmineSipgateConnector
  class Hooks < Redmine::Hook::ViewListener
  
    def helper_user_settings_tabs(context = {})
      context[:tabs] << {:name => 'sipgate', :partial => 'sipgate_connector/user_settings', :label => :label_sipgate, :user => context[:user]}
    end
    
    def helper_easy_contact_tabs(context = {})
      context[:tabs] << { name: 'easy_contact_call_history', label: l(:label_easy_contact_call_history), trigger: 'EntityTabs.showTab(this)', partial: 'sipgate_connector/easy_contact_call_history', easy_contact: context[:easy_contact] }
    end
      
    
    def view_layouts_base_html_head(context = {})
      stylesheet_link_tag 'easyredmine_sipgate', :plugin => 'easyredmine_sipgate_connector'
    end
  end
end  