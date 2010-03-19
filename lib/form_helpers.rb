module ActionView

  #mattr_accessor :live_validations
  #ActionView::live_validations = true

  module Helpers
    module FormHelper

      def jquery_validation_for(object_name, object = nil)
        object ||= self.instance_variable_get("@#{object_name.to_s}")
        validations = object.class.live_validations.dup rescue {}
        #Rails.logger.debug "!!! object.class=#{object.class.column_names.pretty_inspect}"
        #Rails.logger.debug "!!! validations=#{validations.inspect}"

        validations[:rules] ||= {}
        validations[:rules] = validations[:rules].inject({}) do |hash, (attr_name, value)|
          # AR lets you do validates_presence_of :company but on the form it will be company_id
          if !"#{attr_name}".to_s.in?(object.class.column_names) && "#{attr_name}_id".in?(object.class.column_names)
            attr_name = "#{attr_name}_id"
          end

          qualified_attr_name = "#{object_name}[#{attr_name}]"
          #Rails.logger.debug "hash[#{qualified_attr_name}] = #{value.inspect}"
          hash[qualified_attr_name] = value
          hash
        end

        validations
      end

    end
  end
end
