ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, :force => true do |t|
    t.string :role
    t.references :instance
    t.timestamps
  end

  create_table :instances, :force => true do |t|
    t.string :role
    t.timestamps
  end

  create_table :user2s, :force => true do |t|
    t.string :status
    t.references :instance2
    t.timestamps
  end

  create_table :instance2s, :force => true do |t|
    t.string :status
    t.timestamps
  end
end
