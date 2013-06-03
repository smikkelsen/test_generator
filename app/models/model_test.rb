class ModelTest < ActiveRecord::Base
  attr_accessible :project_id, :ip_address, :name, :model_associations_attributes, :model_columns_attributes, :timestamps

  before_save :format_name

  has_many :model_columns, :dependent => :destroy
  has_many :model_associations, :dependent => :destroy
  accepts_nested_attributes_for :model_associations, :reject_if => lambda { |a| a[:related_model_test_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :model_columns, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true

  validates :name, :presence => true


  private
  def format_name
    self.name = self.name.titleize
    self.name.gsub!(' ', '')
  end

end
