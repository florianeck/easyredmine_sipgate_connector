module EasyredmineSipgateConnector
  module UserExtension
  
    extend ActiveSupport::Concern
    
    included do
      serialize :sipgate_devices
    end
    
    def reload_sipgate_devices
      return false if sipgate_token.nil?
      data = rusip_api.devices_for_user(self.sipgate_user_id)
      self.sipgate_devices = {}
      data['items'].map do |item|
        self.sipgate_devices[item['id']] = item['alias'] 
      end
      
      if self.sipgate_default_device_id.present? && self.sipgate_devices[self.sipgate_default_device_id].nil? || self.sipgate_devices.size == 1
        self.sipgate_default_device_id = self.sipgate_devices.keys.first
      end
        
    end
    
    def sipgate_active?
      self.sipgate_user_id.present? && self.sipgate_token.present?
    end
    
    def make_call(deviceid, callee)
      rusip_api.calls(deviceid, callee)
    end
    
    def rusip_api
      @_rusip_api ||= RuSip::Api.new(self.sipgate_token)
    end
    
  end
end  