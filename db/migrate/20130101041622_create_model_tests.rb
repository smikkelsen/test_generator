class CreateModelTests < ActiveRecord::Migration
  def change
    create_table :model_tests do |t|
      t.references :project
      t.string :name, :limit => 32, :null => false
      t.text :description

      t.timestamps
    end
    add_index :model_tests, :project_id

  end
end
