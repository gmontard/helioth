module Helioth
  class Features

    attr_accessor :list

    def initialize(&block)
      @list = Array.new
      instance_eval(&block)
    end

    def feature(name, &block)
      @list << Feature.new(name, &block)
    end
  end
end
