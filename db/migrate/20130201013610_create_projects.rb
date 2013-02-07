class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :ip_address, :limit => 16
      t.string :name, :limit => 32, :null => false
      t.text :description
      t.string :project_manager, :limit => 32
      t.string :developer, :limit => 32

      t.timestamps
    end

  end
end
