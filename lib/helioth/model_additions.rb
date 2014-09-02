module Helioth
  module Modeladditions

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_helioth_role(*args)
        send :include, InstanceMethods
        add_role_validation(args)
      end

      def add_role_validation(args)
        options = args.extract_options!
        role_column = options[:column] || :role
        roles = roles_for(args.first)

        self.send(:validates, role_column.to_sym, inclusion: { in: roles, message: "%{value} is not a valid value" }, allow_blank: true)
      end

      def roles_for(options)
        case options when :user
          roles = helioth.roles.user.map(&:to_s)
        when :instance
          roles = helioth.roles.instance.map(&:to_s)
        else
          raise "Invalid option #{options} for method #{__method__}"
        end
      end

      ##TODO Need to find an other way than re-instanciate the class a second time...
      def helioth
        @helioth ||= ::HeliothDsl.new()
      end
    end

    module InstanceMethods
      def role?
        role.to_sym
      end

      def is_role?(role)
        self.role.to_sym == role.to_sym
      end
    end
  end
end

if defined? ActiveRecord::Base
  ActiveRecord::Base.class_eval do
    include Helioth::Modeladditions
  end
end
