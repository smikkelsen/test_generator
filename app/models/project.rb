class Project < ActiveRecord::Base
  attr_accessible :description, :developer, :name, :project_manager, :ip_address

  has_many :model_tests, :dependent => :destroy
  has_many :project_comments, :dependent => :destroy

  validates :name, :presence => true

end
