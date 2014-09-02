module Helioth
  class Feature

    attr_accessor :name

    def initialize(name, &block)
      @actions = Array.new
      @name = name
      @locales = I18n.available_locales
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
          @actions << Action.new(action, &block)
        }
      end
    end

    def action(action_name)
      @actions.map{|action|
        action if action.name == action_name
      }.compact.first
    end

    def locales(*locales)
      unless locales.empty?
        @locales = locales
      end
      @locales
    end
  end
end
