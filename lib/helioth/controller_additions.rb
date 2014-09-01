module Helioth
  module ControllerAdditions

    module ClassMethods
      def load_and_authorize_for(*args)
        ControllerResource.add_before_filter(self, :load_and_authorize_for, *args)
      end
    end

    def access_to?(feature, *actions)
      return false if !locale_access_to?(feature)
      return true if user_access_to?(feature, *actions)
      return true if instance_access_to?(feature, *actions)
      return false
    end

    def locale_access_to?(feature)
      helioth.authorized_for_locale?(feature, I18n.locale)
    end

    def user_access_to?(feature, *actions)
      helioth.authorized_for_instance?(feature, actions, current_instance.role?)
    end

    def instance_access_to?(feature, *actions)
      helioth.authorized_for_user?(feature, actions, current_user.role?)
    end

    def helioth
      @helioth ||= ::HeliothDsl.new()
    end

    def self.included(base)
      base.extend ClassMethods
      base.helper_method :access_to?, :locale_access_to?, :user_access_to?, :instance_access_to?, :helioth
    end
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include Helioth::ControllerAdditions
  end
end
