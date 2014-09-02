## WARNING: Development in progress

## What is the purpose of this Gem?

First of all this is not an other authorization gem!
The whole concept is about "Feature rolling" and "Feature flipping" which we can resume to "Feature enabling"!

**The idea is to dynamically enable (and disable) application feature depending on the user status (ex: beta, standard) and the feature stage (ex: beta, production). Then the purpose is to make this process easy, dynamic and as much automatic as possible!**

### So how does it works?

The Gem let you describe in a simple DSL a set of possible status for user, instance (group of users) and feature. Then you describe the relation (mapping) between each feature status and a set of user and instance status.

Finally you describe all your application feature and their respective release status.

At the end you get access to the (not so) magic **access_to?(:feature_name)** method that does all the hard work to tell you **true** or **false**!


## Terminology and Concept

In order to use this gem you need to understand those keywords:
- **user**: Define a user of your App
- **instance**: Define a group of users *(optional)*
- **feature**: Define a feature or your App
- **action**: Define a sub-feature of your App *(optional)*
- **status**: Stage of rollout of a feature
- **locales**: I18n locales on which a feature is available. *(optional: by defaut will use *I18n.available_locales*)*

The gem will give you the access status (*true* or *false*) of a feature by checking in this exact order:
1. Is the feature available for the current locale (*I18n.locale*)
2. If it does, check if the user has access to the feature (based on the *relations*)
3. If not, check if the instance has access to the feature (also based on the *relations*)

```ruby
  ## helper method
  def access_to?(feature, *actions)
    return false if !locale_access_to?(feature, *actions)
    return true if helioth.roles.instance.present? && user_access_to?(feature, *actions)
    return true if helioth.roles.user.present? && instance_access_to?(feature, *actions)
    return false
  end
```


## Setup

#### 1) Configure the DSL

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
    feature :disabled

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
    feature :no_name do
      status :disabled
    end

    feature :tutoring do
      status :pre_release

      actions :search, :send do ## this is optional
        status :beta
        locales :fr ## this is optional
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

#### 2) Configure your Models

- You need to link the roles *user* and *instance* to your corresponding model.
In order to do that use the class method *has_helioth_role* in your corresponding models:
```ruby
  class MyUser < ActiveRecord::Base
    ...
    has_helioth_role :user
    ...
  end

  class MyInstance < ActiveRecord::Base
    ...
    has_helioth_role :instance
    ...
  end
```

- By default the Gem will look for a column named "role".
You can configure an other column by using the *column:* option with the *has_helioth_role* method:
 ```ruby
   class MyUser < ActiveRecord::Base
     ...
     has_helioth_role :user, column: "my_role_column"
     ...
   end
 ```


## How to use

- In your controller and view you have access to the *access_to?* helper method:
```ruby
  access_to?(:feature_name)
  #OR
  access_to?(:feature_name, :action_name)
```

- For example you can use this method to change the behavior of your view:
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
Those helpers must return an instance of *User* and *Instance* class where your defined the *has_helioth_role* class method.

- Your *User* and *Instance* models need to inherit from *ActiveRecord::Base*


## FAQ
- **Why using the keyword *instance*?**
At my [company](http://www.vodeclic.com) we do a B2B SaaS App. Then our customers are companies that buy licence for their employees (aka users).
For each customers we let them manage and configure (deeply) their own version of the App, this is an *Instance*.

## Testing the Gem
Inside the repo you'll find a simple Rails app that live in the */test/dummy* directory, start and play!
```system
  cd test/dummy && bundle install && rails s
```

## Disclaimer
- This code is nowhere ready for any usage!
- Some of the code is inspired by the [CanCan](https://github.com/ryanb/cancan/) Gem.
