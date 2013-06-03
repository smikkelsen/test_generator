class AddTimestampsToModelTests < ActiveRecord::Migration
  def change
    add_column :model_tests, :timestamps, :boolean, :default => true
  end
end
