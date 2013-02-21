class AddDataTypeToModelColumns < ActiveRecord::Migration
  def change
    add_column :model_columns, :data_type, :string, :default => 'string'
  end
end
