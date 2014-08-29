require 'helioth'

## En rails utiliser I18n.available_locales
LOCALES = [:fr, :en, :pt]

auth = Helioth.new

## Set roles for User, Instance and Feature
auth.roles do
  user :beta, :standard
  instance :beta, :standard, :critical
  feature :beta, :pre_release, :production
end

## Set authorization for feature based on user and instance role
auth.relations do
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
auth.features do
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

########################
###### ShowCase ########
########################

puts "-----------------------"
puts "----> Roles check <----"
puts "-----------------------\n\n"

puts "User roles are:"
puts auth.roles.user
puts "\n"

puts "Instance roles are:"
puts auth.roles.instance
puts "\n"

puts "Feature roles are:"
puts auth.roles.feature
puts "\n"

puts "--------------------------"
puts "----> Features check <----"
puts "--------------------------\n\n"

puts "Number of feature availables:"
puts auth.features.size
puts "\n"


puts "Availables features:"
puts auth.features.map(&:name)
puts "\n"

puts "First feature has status:"
puts auth.features.first.status
puts "\n"

puts "First feature has actions:"
puts auth.features.first.actions.map(&:name)
puts "\n"

puts "First feataure first action has status:"
puts auth.features.first.actions.first.status
puts "\n"

puts "---------------------------------------"
puts "----> Feature authorization check <----"
puts "---------------------------------------\n\n"

puts "Finding feature with name :tutoring"
puts auth.feature(:tutoring).name
puts "\n"

puts "Finding feature with name :tutoring and action :index"
puts auth.feature(:tutoring, :index).name
puts "\n"

puts "Is feature :tutoring authorized for locale :en?"
puts auth.authorized_for_locale?(:tutoring, :en)
puts "\n"

puts "Is feature :tutoring authorized for user role :beta"
puts auth.authorized_for_user?(:tutoring, :beta)
puts "\n"

puts "Is feature :tutoring with action :send authorized for user role :critical"
puts auth.authorized_for_user?(:tutoring, :send, :critical)
puts "\n"

puts "Is feature :tutoring authorized for instance role :beta"
puts auth.authorized_for_instance?(:tutoring, :beta)
puts "\n"

puts "Is feature :tutoring with action :send authorized for instance role :beta"
puts auth.authorized_for_instance?(:tutoring, :send, :beta)
puts "\n"

puts "Is feature :tutoring with actions :send and :index is authorized for instance role :pre_release"
puts auth.authorized_for_instance?(:tutoring, [:send, :index], :pre_release)
puts "\n"
