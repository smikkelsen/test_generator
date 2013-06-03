class AddAttrAccessorToModelColumns < ActiveRecord::Migration
  def change
    add_column :model_columns, :attr_accessor, :boolean, :default => false
  end
end
