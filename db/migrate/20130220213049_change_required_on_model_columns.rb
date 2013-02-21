class ChangeRequiredOnModelColumns < ActiveRecord::Migration
  def change
    change_column :model_columns, :required, :boolean, :default => false
  end

end
