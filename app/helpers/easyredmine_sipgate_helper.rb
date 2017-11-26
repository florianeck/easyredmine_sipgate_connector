module EasyredmineSipgateHelper
  
  def easy_contact_call_link(contact)
    phone_nr = contact.custom_field_value(EasyContacts::CustomFields.telephone_id).strip
    if phone_nr.present? && User.current.sipgate_active?
      render "sipgate_connector/make_call_link", phone_nr: phone_nr
    else
      contant_tag :span, phone, class: 'sipgate-phone-container phone-placeholder'
    end
  end
  
end