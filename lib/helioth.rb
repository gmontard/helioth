require "helioth/version"
require 'helioth/dsl'
require 'helioth/role'
require 'helioth/relation'
require 'helioth/features'
require 'helioth/feature'
require 'helioth/action'
require 'helioth/controller_additions'
require 'helioth/controller_resource'
require 'helioth/model_additions'

module Helioth

  def self.dsl(file = nil)
    Helioth.const_set("DSL", Helioth::Dsl.load(file)) unless const_defined?("DSL")
  end

  def self.const_missing(name)
    if name == :DSL
      Helioth.dsl
    else
      super
    end
  end
end
