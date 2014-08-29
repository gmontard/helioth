module Helioth
  module ControllerAdditions
    def access_to?(feature, *actions)
      return false if !helioth.authorized_for_locale?(feature, I18n.locale)
      return true if helioth.authorized_for_instance?(feature, actions, current_user.instance.role?)
      return true if helioth.authorized_for_user?(feature, actions, current_user.role?)
      return false
    end

    def helioth
      @helioth ||= ::HeliothDsl.new()
    end

    def self.included(base)
      base.helper_method :access_to?
    end
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include Helioth::ControllerAdditions
  end
end
