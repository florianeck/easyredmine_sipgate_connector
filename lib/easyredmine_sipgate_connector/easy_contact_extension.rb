module EasyredmineSipgateConnector
  module EasyContactExtension
  
    extend ActiveSupport::Concern
    
    included do
      after_save :store_cached_telephone
      has_many :sipgate_call_histories
    end
    
    def telephone
      custom_field_value(EasyContacts::CustomFields.telephone_id)
    end
    
    private
    
    def store_cached_telephone
      phone_vals = self.custom_values.select {|f| f.custom_field.field_format == 'telephone' }.map {|f| f.value }
      self.update_column :telephone_cached, phone_vals.map {|v| v.gsub(/[\ \-\.\/]/, '') }.join(" ") 
    end
      
  end
end  