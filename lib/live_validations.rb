#Rails.logger.debug "!!! vendor/plugins/live_validation_for_rails/lib/live_validations.rb"
module ActiveRecord
  module Validations
#    LIVE_VALIDATIONS_OPTIONS = {
#      :failureMessage => :message,
#      :pattern => :with,
#      :onlyInteger => :only_integer
#    }
#    # more complicated mappings in ar_validation_to_jquery method
#
    ValidationMethods = [
      :presence,
      :numericality,
      :format,
      :length,
      :acceptance,
      :confirmation,
    ]


    module ClassMethods

      ValidationMethods.each do |type|
        define_method "validates_#{type}_of_with_live_validations".to_sym do |*args|
          send "validates_#{type}_of_without_live_validations".to_sym, *args
          record_validations(type, args)
        end
        alias_method_chain "validates_#{type}_of".to_sym, :live_validations
      end

      def live_validations
        @live_validations ||= {}
        @live_validations[:rules] ||= {}
        @live_validations
      end

      private

      def record_validations(type, args)
        live_validations # initialize
        options = (args.last.is_a?(Hash) ? args.pop : {})
        attr_names = args.map(&:to_sym)

        attr_names.each do |attr_name|
          #qualified_attr_name = "#{self.name.underscore}[#{attr_name}]"
          #Rails.logger.debug "!!! #{self}: adding #{type} validation for #{attr_name}: #{options.inspect}"
          ar_validation_to_jquery(attr_name, type, options.dup)
          #Rails.logger.debug "!!!   @live_validations[:rules][#{attr_name}]=#{@live_validations[:rules][attr_name].inspect}"
        end
      end

      def ar_validation_to_jquery(attr_name, type, options)
        rules = @live_validations[:rules][attr_name] ||= {}
        case type
        when :presence
          rules[:required] = true
        else
        end

#        if type == :numericality
#          if configuration[:onlyInteger]
#            configuration[:notAnIntegerMessage] = configuration.delete(:failureMessage)
#          else
#            configuration[:notANumberMessage] = configuration.delete(:failureMessage)
#          end
#        end
#        if type == :length and range = ( configuration.delete(:in) || configuration.delete(:within) )
#          configuration[:minimum] = range.begin
#          configuration[:maximum] = range.end
#        end
#        if type == :confirmation
#          configuration[:match] = self.to_s.underscore + '_' + attr_name.to_s + '_confirmation'
#        end
#        configuration[:validMessage] ||= ''
#        configuration.reject {|k, v| v.nil? }
      end
    end
  end
end
