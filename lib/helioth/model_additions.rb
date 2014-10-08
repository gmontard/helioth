module Helioth
  module ModelAdditions
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_helioth_role(*args)
        options = args.extract_options!
        @@role_column = options[:column] || :role
        @@role_instance = args.first

        add_role_validation

        define_method @@role_column do
          super().to_sym
        end

        define_method "#{@@role_column}?" do
          warn "[DEPRECATED] ##{@@role_column}? is deprecated. Please use ##{@@role_column} instead."
          public_send(@@role_column).to_sym
        end

        define_method "helioth_role?" do
          public_send("#{@@role_column}?")
        end

        define_method "is_#{@@role_column}?" do |arg|
          public_send(@@role_column) == arg.to_sym
        end
      end

      def add_role_validation
        validates @@role_column.to_sym, inclusion: { in: available_roles, message: "%{value} is not a valid value" }, allow_blank: true
      end

      def available_roles
        case @@role_instance
        when :user
          DSL.roles.user
        when :instance
          DSL.roles.instance
        else
          raise "Invalid option #{options} for method #{__method__}"
        end
      end
    end
  end
end

if defined? ActiveRecord::Base
  ActiveRecord::Base.class_eval do
    include Helioth::ModelAdditions
  end
end
