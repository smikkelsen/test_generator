class ModelColumn < ActiveRecord::Base
  belongs_to :model_test
  attr_accessible :db_index, :mass_assign, :max_length, :min_length, :name, :required, :unique, :data_type, :unique_scope,
                  :attr_accessor

  validates :name, :presence => true

  before_save :format_name
  before_save :clear_empty_array

  #REQUIRED_OPTIONS = [["No", "no"], ["Presence", "presence_of"], ["Acceptance", "acceptance_of"]]
  REQUIRED_OPTIONS_PM = [["No", "no"], ["Required Field", "presence_of"], ["Must Check Box", "acceptance_of"]]
  DATA_TYPE_OPTIONS = [
      %w[Binary binary], %w[Boolean boolean], %w[Date date], ['Date / Time', 'datetime'],
      %w[Decimal decimal], %w[Float float], %w[Integer integer], ['Primary Key', 'primary_key'],
      %w[References references], %w[String string], %w[Text text], %w[Time time], %w[Timestamp timestamp]
  ]
  PLURAL_EXCEPTIONS = %w[terms]

  serialize :unique_scope, Array

  scope :by_accessor, ->(val) { where('attr_accessor = ?', val) }

  def self.plural_exception?(string)

    PLURAL_EXCEPTIONS.each do |exception|
      return true if string == exception
    end
    return false
  end

  def min_length
    min_length = super()
    unless min_length.blank?
      if self.data_type.in? %w[float decimal]
        min_length.gsub!(' ', '')
        min_length = min_length.split(',')
        min_length[0] = min_length[0].to_i ||= 0
        min_length[1] = min_length[1].to_i ||= 0
      else
        min_length = min_length.to_i
      end
      min_length
    end
  end

  def max_length
    max_length = super()
    unless max_length.blank?
      if self.data_type.in? %w[float decimal]
        max_length.gsub!(' ', '')
        max_length = max_length.split(',')
        max_length[0] = max_length[0].to_i ||= 0
        max_length[1] = max_length[1].to_i ||= 0
      else
        max_length = max_length.to_i
      end
      max_length
    end
  end

  private

  def clear_empty_array
    self.unique_scope.reject!(&:blank?)
    #self.unique_scope.reject!(&:empty?)
  end

  def format_max_length
    self.max_length.gsub!(' ', '')
  end

  def format_name
    last_three = self.name.reverse[0..2].reverse
    id_it = true if last_three == '_id'
    self.name = self.name.titleize # this removes _id

    self.name = self.name + '_id' if id_it # this puts id back on if it was there
    self.name.gsub!(' ', '')
    self.name = self.name.underscore
    self.name.downcase!

    if self.data_type == 'references'
      last_three = self.name.reverse[0..2].reverse
      unless last_three == '_id'
        self.name = "#{self.name}_id"
      end
    end

  end


end


