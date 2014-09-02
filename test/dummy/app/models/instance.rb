class Instance < ActiveRecord::Base
  has_many :users

  has_helioth_role :instance, column: :role
end
