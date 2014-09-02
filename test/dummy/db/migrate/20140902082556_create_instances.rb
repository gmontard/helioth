class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.string :role

      t.timestamps
    end
  end
end
