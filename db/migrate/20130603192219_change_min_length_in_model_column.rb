class ChangeMinLengthInModelColumn < ActiveRecord::Migration
  def change
    change_column :model_columns, :min_length, :string

  end
end
