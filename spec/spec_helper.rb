require 'pry'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)

require 'Helioth'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
