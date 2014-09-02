module Helioth
  module Dsl
    ## Configure roles
    def roles(&block)
      @roles ||= Role.new(&block)
    end

    ## Configure relations
    def relations(&block)
      @relations ||= Relation.new(&block)
    end

    ## Configure features
    def features(&block)
      if block
        @features ||= Features.new(&block)
      else
        @features.list
      end
    end

    ## Get feature
    def feature(feature_name, action_name=nil)
      if action_name.nil?
        get_feature(feature_name)
      else
        get_action(feature_name, action_name)
      end
    end

    ## Get feature
    def get_feature(feature_name)
      @features.list.map{|feature|
        feature if feature.name == feature_name
      }.compact.first
    end

    ## Get feature action
    def get_action(feature_name, action_name)
      get_feature(feature_name).actions.map{|action|
        action if action.name == action_name
      }.compact.first
    end

    ## Check authorization
    def authorized_for_locale?(feature_name, *actions_name, locale)
      if feature = feature(feature_name)
        access = Array.new
        access << feature.locales.include?(locale)

        if actions_name.flatten.any?
          access += actions_name.flatten.map{|action_name|
            feature(feature_name).action(action_name).locales.include?(locale)
          }
        end

        access.all?
      else
        raise "Feature not found"
        false
      end
    end

    def authorized_for_user?(feature_name, *actions_name, role)
      authorized_for_type?(feature_name, actions_name.flatten, role, :user)
    end

    def authorized_for_instance?(feature_name, *actions_name, role)
      authorized_for_type?(feature_name, actions_name.flatten, role, :instance)
    end

    protected
    def authorized_for_type?(feature_name, actions_name, role, type)

      feature = feature(feature_name)
      actions = actions_name.flatten.map{|action_name|
        feature(feature_name, action_name)
      }

      if feature

        ## If a feature doesn"t have relation. For ex for a disabled status
        return false if relations.feature[feature.status].blank?

        access = Array.new
        access << relations.feature[feature.status][type].include?(role)

        if actions.any?
          access += actions.map{|action|
            relations.feature[action.status][type].include?(role)
          }
        end

        access.all?
      else
        raise "Feature not found"
        false
      end
    rescue
      raise "Error in method #{__method__} of #{__FILE__}"
      false
    end
  end
end
