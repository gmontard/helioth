module Helioth
  class Features

    attr_accessor :list

    def initialize(&block)
      @list = Array.new
      instance_eval(&block)
    end

    def feature(name, &block)
      if block.nil?
        @list
      else
        @list << Feature.new(name, &block)
      end
    end
  end
end
