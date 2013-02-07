class ProjectComment < ActiveRecord::Base
  attr_accessible :comment, :resources

  belongs_to :project

  validates :comment, :presence => true

end
