module Helioth
  class Action

    attr_accessor :name, :feature

    def initialize(feature, name, &block)
      @name = name
      @feature = feature
      instance_eval(&block)
    end

    def status(status=nil)
      @status ||= status
    end
  end
end
