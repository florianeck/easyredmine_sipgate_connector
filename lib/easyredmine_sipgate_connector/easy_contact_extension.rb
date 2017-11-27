module EasyredmineSipgateConnector
  module EasyContactExtension
  
    extend ActiveSupport::Concern
    
    included do
      before_save :store_cached_telephone
    end
    
    def telephone
      custom_field_value(EasyContacts::CustomFields.telephone_id)
    end
    
    private
    
    def store_cached_telephone
      self.telephone_cached = self.telephone.gsub(/[\ \-\.\/]/, '')
    end
      
  end
end  