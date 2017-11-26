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
  
    def scope
      'all'
    end
  
    def client_id
      config_from_yaml['client_id']
    end
  
    def client_secrect
      config_from_yaml['client_secret']
    end
  
    def redirect_url
      Rails.application.routes.url_helpers.sipgate_callback_url(host: config_from_yaml['redirect_host'])
    end
  end
  
  class Hooks < Redmine::Hook::ViewListener
    
    def helper_user_settings_tabs(context = {})
      context[:tabs] << {:name => 'sipgate', :partial => 'sipgate_connector/user_settings', :label => :label_sipgate, :user => context[:user]}
    end
  end
      
end