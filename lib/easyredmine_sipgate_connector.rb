require "ru_sip"

module EasyredmineSipgateConnector
  
  CONFIG_FILE_PATH         = File.expand_path("../../config/easyredmine_sipgate_connector.yml", __FILE__)
  
  cattr_reader :yaml_config
  
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
      
end