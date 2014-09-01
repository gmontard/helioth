## WARNING: Development in progress

## What is the purpose of this Gem?

First of all this is not an other authorization gem!
The whole concept is about "Feature rolling" and "Feature flipping" which we can resume to "Feature enabling"!

**The idea is to dynamically enable (and disable) application feature depending on the user status (ex: beta, standard) and the feature stage (ex: beta, production). Then the purpose is to make this process easy, dynamic and as much automatic as possible!**

#### So how does it works?

The Gem let you describe in a simple DSL a set of possible status for user, instance (group of users) and feature. Then you describe the relation (mapping) between each feature status and a set of user and instance status.

Finally you describe all your application feature and their respective release status.

At the end you get access to the (not so) magic **access_to?(:feature_name)** method that does all the hard work to tell you **true** or **false**!


## Preview Version:
### Setup the Gem

- Add a file called "helioth_dsl.rb" inside your model folder and copy paste this code
```ruby
  class HeliothDsl
    include Helioth::Base

    def initialize
    end
  end
```

- Now it's time to configure the Gem.
First describe the different roles (*user*, *instance* and *feature*) and affect each of them a set of status:
```ruby
  roles do
    user :beta, :standard
    instance :beta, :standard, :critical
    feature :disabled, :beta, :pre_release, :production
  end
```

- Then describe the relations between *feature* status and *user* and *instance* status:
```ruby
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
```

- Now describe your application *features*:
```ruby
  features do
    feature :no_name
      status :disabled
    end

    feature :tutoring do
      status :pre_release

      actions :search, :send do ## this is optional
        status :beta
      end

      actions :index do
        status :production
      end
    end

    feature :social_learning do
      status :beta
      locales :fr, :en ## this is optional
    end
  end
```
As you can see *:actions* and *:locales* are optional. Those give you more flexibility over the rollout process.
You can find this complete DSL example inside the */examples* directory.

### Using the Gem

- In your controller and view you have access to the helper method:
```ruby
  access_to?(:feature_name)
  #OR
  access_to?(:feature_name, :action_name)
```

- For example you can use this method to change the bahavior of your view:
```ruby
  if access_to?(:tutoring, :search)
    link_to tutoring_path()
  end
```

- There is also a DSL available to define at a controller level the access:
```ruby
  ## Declare if an entire controller is accessible based on a specific feature
  load_and_authorize_for :feature_name

  ## Declare if a controller method (:index) is accessible based on an action (:index) related to a feature (:tutoring)
  load_and_authorize_for :tutoring, :action=>:index, :only => :index

  ## Declare if a controller method (:search) is accessible based on a multiple actions (:index, :search) related to a feature (:tutoring)
  load_and_authorize_for :tutoring, :actions=>[:search, :index], :only => :search

  ## All before_filter keywords are available:
  :only, :except, :if, :unless
```

## Pre-requisite

- Internally this Gem rely on two helper methods that must be available in your app:
```ruby
  current_user
  #AND
  current_instance
```
Those two methods must return an object which respond to the 'role?' method and return one for the status declared (*user* status for current_user and *instance* status for current_instance).
```ruby
  ## For testing purpose ONLY ##
  class ApplicationController < ActionController::Base
    helper_method :current_user, :current_instance

    def current_user
      User.new(role: "standard", instance:{role: "standard"})
    end

    def current_instance
      current_user.instance
    end
  end

  class User
    attr_accessor :role, :instance

    def initialize(role: role, instance: {role: role})
      @role = role
      @instance = Instance.new(instance)
    end

    def role?
      self.role.to_sym
    end
  end

  class Instance
    attr_accessor :role

    def initialize(role: role)
      @role = role
    end

    def role?
      self.role.to_sym
    end
  end
```

## Testing the Gem
Inside the repo you'll find a simple Rails app that live in the */test/dummy* directory, start and play!
```system
  cd test/dummy && bundle install && rails s
```

## Disclaimer
- This code is nowhere ready for any usage!
- Some of the code is heavily inspired by the [CanCan](https://github.com/ryanb/cancan/) Gem.
