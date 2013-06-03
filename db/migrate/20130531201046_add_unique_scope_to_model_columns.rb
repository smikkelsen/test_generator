class AddUniqueScopeToModelColumns < ActiveRecord::Migration
  def change
    add_column :model_columns, :unique_scope, :string
  end
end
