class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :role
      t.references :instance, index: true

      t.timestamps
    end
  end
end
