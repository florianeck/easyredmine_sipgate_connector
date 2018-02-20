class SipgateCallHistoryDashboard < EasyPageModule
  include EasyUtils::DateUtils

  def category_name
    @category_name ||= 'users'
  end

  def runtime_permissions(  user)
    user.sipgate_active?
  end
  
  def show_path
    'sipgate_connector/call_history_dashboard'
  end

end
