class ModelAssociation < ActiveRecord::Base
  belongs_to :model_test
  attr_accessible :related_model_test_id, :relationship_type

  validates :related_model_test_id, :presence => true
  validates :relationship_type, :presence => true

  TYPE_OPTIONS = [["Has One", "have_one"],["Has Many", "have_many"],["Belongs To", "belong_to"],["Has and Belongs to Many", "have_and_belong_to_many"]]

end
