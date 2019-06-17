class SipgateCallHistoryDashboard < EasyPageModule
  include EasyUtils::DateUtils

  def category_name
    @category_name ||= 'users'
  end

  def runtime_permissions(user)
    user.sipgate_active?
  end

  def show_path
    'sipgate_connector/easy_page_modules/call_history_dashboard_show'
  end

  def edit_path
    'sipgate_connector/easy_page_modules/call_history_dashboard_edit'
  end

  def get_show_data(settings, user, page_context = {})
    { entries: SipgateCallHistory.where(user_id: user.id).limit(settings['page_size'] || 10) }
  end

end
