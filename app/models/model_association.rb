class ModelAssociation < ActiveRecord::Base
  belongs_to :model_test
  attr_accessible :related_model_test_id, :relationship_type

  validates :related_model_test_id, :presence => true
  validates :relationship_type, :presence => true

  TYPE_OPTIONS = [["Has One", "have_one"], ["Has Many", "have_many"], ["Belongs To", "belong_to"], ["Has and Belongs to Many", "have_and_belong_to_many"]]

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
end
