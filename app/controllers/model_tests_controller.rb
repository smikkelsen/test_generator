class ModelTestsController < ApplicationController

  before_filter :set_role

  # GET /model_tests/new
  def new
    @model_test = ModelTest.new(params[:model_test])
    inspect_obj "params", params
    @model_tests = ModelTest.find_all_by_project_id(@model_test.project_id)
    3.times { @model_test.model_columns.build }
  end

  # GET /model_tests/1/edit
  def edit
    @model_test = ModelTest.find(params[:id])
    @model_tests = ModelTest.find_all_by_project_id(@model_test.project_id)
    if @role == "dev"
      @result = ''
      @result += '<div id="accordion">'
      @result += "\r"

      @result += "<h3>Rails Generator String</h3><div><textarea style='width:98%; height:60px;'>#{build_rails_generator}</textarea></div>"
      @result += "<h3>Attributes Accessible</h3><div><textarea style='width:98%; height:60px;'>#{build_attr_accessible}</textarea></div>"
      @result += "<h3>Rails Model Validations</h3><div><textarea style='width:98%; height:200px;'>#{build_model_validations}</textarea></div>"
      @result += "<h3>Rails Migrations</h3><div><textarea style='width:98%; height:200px;'>#{build_migrations}</textarea></div>"
      @result += "<h3>Rspec Tests</h3><div><textarea style='width:98%; height:200px;'>#{build_model_tests}</textarea></div>"
      @result += "<h3>Rspec Factory</h3><div><textarea style='width:98%; height:200px;'>#{build_model_factory}</textarea></div>"

      @result += '</div>'

      @result = @result.html_safe
    end

  end

  # POST /model_tests
  def create
    @model_test = ModelTest.new(params[:model_test])

    if @model_test.save
      if @role == "dev"
        redirect_to project_path(@model_test.project_id)
      else
        redirect_to project_path(@model_test.project_id)
      end
    else
      render :action => "new"
    end
  end

  # PUT /model_tests/1
  def update
    @model_test = ModelTest.find(params[:id])
    @model_test.update_attributes(params[:model_test])
    inspect_obj "model_test", @model_test
    if @role == "dev"
      redirect_to :action => "edit"
    else
      redirect_to project_path(@model_test.project_id)
    end
  end

  # DELETE /model_tests/1
  def destroy
    @model_test = ModelTest.find(params[:id])
    @model_test.destroy

    #set_message "Successfully Destroyed"
    redirect_to project_path(@model_test.project_id)
  end


  # ===================================================================
  #                          Protected Methods
  # ===================================================================
  protected

  def set_role
    @role = cookies['role']

    raise 'No Role Set' if @role.nil?

  rescue
    redirect_to root_path
  end

  # ====================================================
  #                Test Methods
  # ====================================================
  def build_model_tests

    @result = ''
    @result += "require 'spec_helper'\r\rdescribe #{@model_test.name} do\r\r"
    model_mass_assign_test
    model_indexes_test
    model_associations_test
    @result += "  context 'Validations' do\r\r"
    model_presence_test
    model_length_test
    model_uniqueness_test
    @result += "  end\r\r"
    @result += 'end'
  end

  def model_associations_test
    @result += "  context 'Associations' do\r"
    @model_test.model_associations.each do |asc|
      error_log 'relationship name', asc.model_relationship_name
      @result += "    it { should #{asc.relationship_type} :#{asc.model_relationship_name} }\r"
    end

    @result += "  end\r\r"
  end

  def model_mass_assign_test
    @result += "  context 'Mass Assignment' do\r"
    @model_test.model_columns.each do |col|
      if col.mass_assign
        @result += "    it { should allow_mass_assignment_of :#{col.name} }\r"
      else
        @result += "    it { should_not allow_mass_assignment_of :#{col.name} }\r"
      end
    end
    @result += "  end\r\r"
  end

  def model_indexes_test
    @result += "  context 'Indexes' do\r"
    @model_test.model_columns.each do |col|
      if col.db_index
        @result += "    it { should have_db_index :#{col.name} }\r"
      else
        @result += "    it { should_not have_db_index :#{col.name} }\r"
      end
    end
    @result += "  end\r\r"
  end

  def model_presence_test
    @result += "    context 'Presence' do\r"
    @result += "      #subject { create(:#{@model_test.name.underscore.singularize}) }\r\r"

    @model_test.model_columns.each do |col|
      if col.required
        if col.data_type == "boolean"
          @result += "      it { should validate_acceptance_of :#{col.name} }\r"
        else
          @result += "      it { should validate_presence_of :#{col.name} }\r"
        end
      end
    end
    @result += "    end\r\r"
  end

  def model_uniqueness_test
    @result += "    context 'Uniqueness' do\r"
    @result += "      #subject { create(:#{@model_test.name.underscore.singularize}) }\r\r"

    @model_test.model_columns.each do |col|
      if col.unique
        @result += "      it { should validate_uniqueness_of :#{col.name} }\r"
        @result += "      it { should have_db_index(:#{col.name}).unique(true) }\r"
      else
        @result += "      it { should_not validate_uniqueness_of :#{col.name} }\r"
        @result += "      it { should_not have_db_index(:#{col.name}).unique(true) }\r"
      end
    end
    @result += "    end\r\r"
  end

  def model_length_test
    @result += "    context 'Length' do\r"
    @result += "      #subject { create(:#{@model_test.name.underscore.singularize}) }\r\r"

    @model_test.model_columns.each do |col|
      @result += "      it { should ensure_length_of(:#{col.name}).is_at_least(#{col.min_length}) }\r" if col.min_length
      @result += "      it { should ensure_length_of(:#{col.name}).is_at_most(#{col.max_length}) }\r" if col.max_length
    end
    @result += "    end\r\r"
  end


  # ====================================================
  #                Rails Generator
  # ====================================================
  def build_rails_generator
    text = ''
    text += @model_test.name

    @model_test.model_columns.each do |col|
      if col.data_type == 'references'
        text += " #{col.name.gsub('_id', '')}:#{col.data_type}"
      else
        text += " #{col.name}:#{col.data_type}"
      end
    end
    text
  end

  def build_attr_accessible
    text = ''
    text += 'attr_accessible '

    text += @model_test.model_columns.select { |col| col.mass_assign }.map { |col| ":#{col.name}" }.join(', ')
    text
  end


  # ====================================================
  #                Model Validations
  # ====================================================

  def build_model_validations
    text = ''
    @model_test.model_columns.each do |col|
      text += "validates :#{col.name}"
      if col.presence
        if col.data_type == 'boolean'
          text += ', :acceptance => true' if col.presence
        else
          text += ', :presence => true' if col.presence
        end
      end

      text += ',
            :uniqueness => true' if col.unique
      if col.min_length && col.min_length > 0 || col.max_length && col.max_length > 0
        text += ',
            :length => {'
        text += ":minimum => #{col.min_length}" if col.min_length && col.min_length > 0
        text += ', ' if col.min_length && col.min_length > 0 && col.max_length && col.max_length > 0
        text += ":maximum => #{col.max_length}" if col.max_length && col.max_length > 0
        text += '}'
      end
      text += ',
            :numericality => true' if col.data_type.in? %w[decimal float integer]
      text += "\r"
    end

    text
  end

  # ====================================================
  #                     Migrations
  # ====================================================

  def build_migrations
    text = ''
    text += "create_table :#{@model_test.name.tableize} do |t|\r"
    @model_test.model_columns.each do |col|
      col.name.gsub('_id', '') if col.data_type == 'references'
      text += "  t.#{col.data_type} :#{col.name}"
      text += ', :null => false' if col.presence
      text += ", :limit => #{col.max_length}" if col.max_length
      text += "\r"
    end
    text += "\r"
    text += "  t.timestamps\r"
    text += "end\r"

    @model_test.model_columns.each do |col|
      text += "add_index :#{@model_test.name.tableize}, :#{col.name}\r" if col.db_index
      text += "add_index :#{@model_test.name.tableize}, :#{col.name}, :unique => true\r" if col.unique
    end
    text
  end

  # ====================================================
  #                     Factory
  # ====================================================

  def build_model_factory
    text = ''
    text += "# Read about factories at http://github.com/thoughtbot/factory_girl\r"
    text += "FactoryGirl.define do\r"
    text += "  factory :#{@model_test.name.tableize} do\r"
    @model_test.model_columns.each do |col|
      text += "    #{col.name} ''\r"
    end
    text += "  end\r"
    text += "end\r"

    text
  end


end

#
## Read about factories at http://github.com/thoughtbot/factory_girl
#FactoryGirl.define do
#  factory :map_api_users_domains do
#    api_user_id 1
#    domain_id 1
#  end
#end
