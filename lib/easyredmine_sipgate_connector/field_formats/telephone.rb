module EasyredmineSipgateConnector
  module FieldFormats

    class Telephone < Redmine::FieldFormat::StringFormat
      add 'telephone'

      def label
        :label_telephone
      end

      def formatted_value(view, custom_field, value, customized=nil, html=false)
        html ? view.easy_contact_call_link(value) : value.to_s
      end

    end

  end
end
