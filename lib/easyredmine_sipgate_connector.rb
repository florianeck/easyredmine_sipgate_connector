require "ru_sip"

module EasyredmineSipgateConnector
  
  CONFIG_FILE_PATH         = File.expand_path("../../config/easyredmine_sipgate_connector.yml", __FILE__)
  
  cattr_reader :yaml_config
  class << self
    def config_from_yaml
      return self.yaml_config if self.yaml_config.present?

      if File.exists?(CONFIG_FILE_PATH)
        @@yaml_config = YAML::load(File.open(CONFIG_FILE_PATH).read)
      else
        raise LoadError, "Cant find config file under #{CONFIG_FILE_PATH}"
      end
    end
    
    def history_page_size
      10
    end
    
    def min_call_duration_for_issue_assignment
      config_from_yaml.fetch('min_call_duration_for_issue_assignment', 10).to_i
    end
    
    def call_types_for_issue_assignment
      config_from_yaml.fetch('call_types_for_issue_assignment', ['CALL'])
    end
    
    def scope
      'all'
    end
  
    def client_id
      config_from_yaml['client_id']
    end
  
    def client_secret
      config_from_yaml['client_secret']
    end
  
    def redirect_url
      Rails.application.routes.url_helpers.sipgate_callback_url(host: config_from_yaml['redirect_host'])
    end
  end
  
end

require "easyredmine_sipgate_connector/hooks"
require "easyredmine_sipgate_connector/field_formats/telephone"
require "easyredmine_sipgate_connector/user_extension"
require "easyredmine_sipgate_connector/easy_contact_extension"
require "easyredmine_sipgate_connector/sipgate_call_history_dashboard"

Rails.application.config.after_initialize do
  User.send :include, EasyredmineSipgateConnector::UserExtension
  EasyContact.send :include, EasyredmineSipgateConnector::EasyContactExtension
end

ApplicationController.send :include, EasyredmineSipgateHelper
ApplicationController.send :helper, :easyredmine_sipgate