class CreateProjectComments < ActiveRecord::Migration
  def change
    create_table :project_comments do |t|
      t.references :project
      t.text :comment, :null => false

      t.timestamps
    end
    add_index :project_comments, :project_id
  end
end
