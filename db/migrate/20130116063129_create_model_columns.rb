class CreateModelColumns < ActiveRecord::Migration
  def change
    create_table :model_columns do |t|
      t.references :model_test
      t.string :name, :limit => 32, :null => false
      t.boolean :db_index
      t.string :required, :limit => 32
      t.boolean :unique
      t.boolean :mass_assign, :default => true
      t.integer :min_length, :limit => 4
      t.integer :max_length, :limit => 4

      t.timestamps
    end
    add_index :model_columns, :model_test_id
    add_index :model_columns, :db_index
    add_index :model_columns, :unique
    add_index :model_columns, :mass_assign

  end
end
