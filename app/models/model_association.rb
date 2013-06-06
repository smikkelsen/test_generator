class ModelAssociation < ActiveRecord::Base
  belongs_to :model_test
  attr_accessible :related_model_test_id, :relationship_type

  validates :related_model_test_id, :presence => true
  validates :relationship_type, :presence => true

  TYPE_OPTIONS = {
      1 => {:id => 1, :name => 'Has One', :model => 'has_one', :test => 'have_one'},
      2 => {:id => 2, :name => 'Has Many', :model => 'has_many', :test => 'have_many'},
      3 => {:id => 3, :name => 'Belongs To', :model => 'belongs_to', :test => 'belong_to'},
      4 => {:id => 4, :name => 'Has and Belongs to Many', :model => 'has_and_belongs_to_many', :test => 'have_and_belong_to_many'},
  }

  def model_relationship_name
    related_table = ModelTest.find_by_id(self.related_model_test_id)

    related_table_name = related_table.name
    Rails.logger.debug related_table_name
    case self.relationship_type
      when "have_one"
        tb = related_table_name.singularize
      when "have_many"
        tb = related_table_name.pluralize
      when "have_and_belong_to_many"
        tb = related_table_name.pluralize
      when "belong_to"
        tb = related_table_name.singularize
      else
        tb = related_table_name.singularize
    end
    related_table_name = tb.underscore
    return related_table_name.downcase
    #Rails.logger.debug related_table_name
  end

  def relationship_name
    TYPE_OPTIONS[self.relationship_type.to_i][:name] unless self.relationship_type.nil?
  end

  def model_name
    TYPE_OPTIONS[self.relationship_type.to_i][:model] unless self.relationship_type.nil?
  end

  def test_name
    TYPE_OPTIONS[self.relationship_type.to_i][:test] unless self.relationship_type.nil?
  end

end
