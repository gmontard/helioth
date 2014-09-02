class TestsController < ApplicationController

  load_and_authorize_for :tutoring

  load_and_authorize_for :tutoring, :action=>:index, :only => :index

  load_and_authorize_for :tutoring, :actions=>[:search, :index], :only => :search

  layout "application"

  def index
    # puts "-----------------------"
    # puts "----> Roles check <----"
    # puts "-----------------------\n\n"
    #
    # puts "User roles are:"
    # puts helioth.roles.user
    # puts "\n"
    #
    # puts "Instance roles are:"
    # puts helioth.roles.instance
    # puts "\n"
    #
    # puts "Feature roles are:"
    # puts helioth.roles.feature
    # puts "\n"
    #
    # puts "--------------------------"
    # puts "----> Features check <----"
    # puts "--------------------------\n\n"
    #
    # puts "Number of feature availables:"
    # puts helioth.features.size
    # puts "\n"
    #
    #
    # puts "Availables features:"
    # puts helioth.features.map(&:name)
    # puts "\n"
    #
    # puts "First feature has status:"
    # puts helioth.features.first.status
    # puts "\n"
    #
    # puts "First feature has actions:"
    # puts helioth.features.first.actions.map(&:name)
    # puts "\n"
    #
    # puts "First feataure first action has status:"
    # puts helioth.features.first.actions.try(:first).try(:status)
    # puts "\n"
    #
    # puts "---------------------------------------"
    # puts "----> Feature heliothorization check <----"
    # puts "---------------------------------------\n\n"
    #
    # puts "Finding feature with name :tutoring"
    # puts helioth.feature(:tutoring).name
    # puts "\n"
    #
    # puts "Finding feature with name :tutoring and action :index"
    # puts helioth.feature(:tutoring, :index).name
    # puts "\n"
    #
    # puts "Is feature :tutoring authorized for locale :en?"
    # puts helioth.authorized_for_locale?(:tutoring, :en)
    # puts "\n"
    #
    # puts "Is feature :tutoring authorized for user role :beta"
    # puts helioth.authorized_for_user?(:tutoring, :beta)
    # puts "\n"
    #
    # puts "Is feature :tutoring with action :send authorized for user role :critical"
    # puts helioth.authorized_for_user?(:tutoring, :send, :critical)
    # puts "\n"
    #
    # puts "Is feature :tutoring authorized for instance role :beta"
    # puts helioth.authorized_for_instance?(:tutoring, :beta)
    # puts "\n"
    #
    # puts "Is feature :tutoring with action :send authorized for instance role :beta"
    # puts helioth.authorized_for_instance?(:tutoring, :send, :beta)
    # puts "\n"
    #
    # puts "Is feature :tutoring with actions :send and :index is authorized for instance role :pre_release"
    # puts helioth.authorized_for_instance?(:tutoring, [:send, :index], :pre_release)
    # puts "\n"
  end

  def search
  end


  ## For testing purpose
  helper_method :current_user, :current_instance
  def current_user
    User.new(role: "standard", instance_attributes:{role: "standard"})
  end

  def current_instance
    current_user.instance
  end
end
