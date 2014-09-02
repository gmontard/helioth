class User < ActiveRecord::Base
  belongs_to :instance
  accepts_nested_attributes_for :instance

  has_helioth_role :user, column: :role
end
