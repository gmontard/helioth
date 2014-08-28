module Helioth
  class Relation

    def initialize(&block)
      @feature = Hash.new
      instance_eval(&block)
    end

    def feature(status = nil, &block)
      if block.nil?
        @feature
      else
        @@tmp = Hash.new
        instance_eval(&block)
        @feature[status] = @@tmp
      end
    end

    def instance(*status)
      @@tmp.merge!({instance: status})
    end

    def user(*status)
      @@tmp.merge!({user: status})
    end
  end
end
