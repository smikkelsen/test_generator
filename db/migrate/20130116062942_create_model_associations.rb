class CreateModelAssociations < ActiveRecord::Migration
  def change
    create_table :model_associations do |t|
      t.references :model_test
      t.string :relationship_type, :limit => 32
      t.integer :related_model_test_id, :null => false

      t.timestamps
    end
    add_index :model_associations, :model_test_id
    add_index :model_associations, :related_model_test_id

  end
end
