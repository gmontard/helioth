module Helioth
  class Action

    attr_accessor :name, :feature

    def initialize(name, &block)
      @name = name
      @locales = I18n.available_locales
      instance_eval(&block)
    end

    def status(status=nil)
      @status ||= status
    end

    def locales(*locales)
      unless locales.empty?
        @locales = locales
      end
      @locales
    end
  end
end
