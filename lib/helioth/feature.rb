module Helioth
  class Feature

    attr_accessor :name

    def initialize(name, &block)
      @actions = Array.new
      @name = name
      instance_eval(&block)
    end

    def status(status = nil)
      @status ||= status
    end

    def actions(*actions, &block)
      if block.nil?
        @actions
      else
        actions.each{|action|
          @actions << Action.new(self, action, &block)
        }
      end
    end

    def locales(*locales)
      if locales.empty?
        locales = I18n.available_locales
      end
      @locales ||= locales
    end
  end
end
