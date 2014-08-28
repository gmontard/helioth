module Helioth
  class Role
    def initialize(&block)
      instance_eval(&block)
    end

    def user(*user)
      @user ||= user
    end

    def instance(*instance)
      @instance ||= instance
    end

    def feature(*feature)
      @feature ||= feature
    end
  end
end
