module EasyredmineSipgateHelper
  
  def easy_contact_call_link(phone_nr)
    if phone_nr.present? && User.current.sipgate_active?
      render "sipgate_connector/make_call_link", phone_nr: phone_nr
    else
      content_tag :span, phone_nr, class: 'sipgate-phone-container phone-placeholder'
    end
  end
  
  def sipgate_per_page
    (session[:sipgate_per_page] || EasyredmineSipgateConnector.history_page_size).to_i
  end
  
  def sipgate_pages_count
    (SipgateCallHistory.where(user_id: User.current.id).count/sipgate_per_page.to_f).ceil
  end
  
end