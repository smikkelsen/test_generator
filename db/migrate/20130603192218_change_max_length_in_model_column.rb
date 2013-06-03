class ChangeMaxLengthInModelColumn < ActiveRecord::Migration
  def change
    change_column :model_columns, :max_length, :string

  end
end
