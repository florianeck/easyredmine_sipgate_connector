Redmine::Plugin.register :easyredmine_sipgate_connector do
  name 'EasyRedmine Sipgate Connector'
  author 'Florian Eck for akquinet'
  description 'Connect easyredmine CRM module to Sipgate VoIP Phone system'
  version '1.0'

end

require 'easyredmine_sipgate_connector'


#Rails.application.config.after_initialize do
#  view_path = File.expand_path("../app/views", __FILE__)
#  ActionController::Base.prepend_view_path(view_path)
#  locale_path = File.expand_path("../config/locales/custom.*.yml", __FILE__)
#  I18n.backend.load_translations
#end
