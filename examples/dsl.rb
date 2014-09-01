class HeliothDsl

  include Helioth::Base

  def initialize

    ## Set roles for User, Instance and Feature
    roles do
      user :beta, :standard
      instance :beta, :standard, :critical
      feature :beta, :pre_release, :production
    end

    ## Set authorization for feature based on user and instance role
    relations do
      feature :beta do
        instance :beta
        user :beta
      end

      feature :pre_release do
        instance :beta, :standard
        user :beta
      end

      feature :production do
        instance :beta, :standard, :critical
        user :beta, :standard
      end
    end

    ## Declare features
    features do
      feature :tutoring do
        status :pre_release

        actions :search, :send do
          status :beta
        end

        actions :index do
          status :production
        end
      end

      feature :social_learning do
        status :beta
        locales :fr, :en
      end
    end
  end
end
