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
    @title = @model_test.name
    @model_tests = ModelTest.find_all_by_project_id(@model_test.project_id)
    if @role == "dev"
      @result = ''
      @result += '<div id="accordion">'
      @result += "\r"

      @result += "<h3>Rails Generator String</h3><div><textarea style='width:98%; height:60px;' id='text-generator'>#{build_rails_generator}</textarea></div>"
      @result += "<h3>Model</h3><div><textarea style='width:98%; height:300px;' id='text-model'>#{build_full_model}</textarea></div>"
      @result += "<h3>Model - Attributes Accessible</h3><div><textarea style='width:98%; height:100px;' id='text-attributes'>#{build_attr_accessible}</textarea></div>"
      @result += "<h3>Model - Validations</h3><div><textarea style='width:98%; height:200px;' id='text-validations'>#{build_model_validations}</textarea></div>"
      @result += "<h3>Migrations</h3><div><textarea style='width:98%; height:200px;' id='text-migrations'>#{build_migrations}</textarea></div>"
      @result += "<h3>Rspec - Tests</h3><div><textarea style='width:98%; height:300px;' id='text-tests'>#{build_model_tests}</textarea></div>"
      @result += "<h3>Rspec - Factory</h3><div><textarea style='width:98%; height:200px;' id='text-factory'>#{build_model_factory}</textarea></div>"

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
      @result += "    it { should #{asc.test_name} :#{asc.model_relationship_name} }\r"
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
    accessible = @model_test.model_columns.by_accessor(false)

    @result += "  context 'Indexes' do\r"
    accessible.each do |col|
      if col.db_index
        @result += "    it { should have_db_index :#{col.name} }\r" unless col.unique
      else
        @result += "    it { should_not have_db_index :#{col.name} }\r" unless col.unique
      end
    end
    @result += "  end\r\r"
  end

  def model_presence_test
    @result += "    context 'Presence' do\r"
    @result += "      subject { create(:#{@model_test.name.underscore.singularize}) }\r\r"

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
    @result += "      subject { create(:#{@model_test.name.underscore.singularize}) }\r\r"

    @model_test.model_columns.each do |col|
      if col.unique
        if col.unique_scope.count < 1
          @result += "      it { should validate_uniqueness_of :#{col.name} }\r"
          @result += "      it { should have_db_index(:#{col.name}).unique(true) }\r" unless col.attr_accessor
        else
          @result += "      it { should validate_uniqueness_of(:#{col.name}).scoped_to(#{col.unique_scope.map { |s| ":#{s}" }.join(', ')}) }\r"
        end
      else
        @result += "      it { should_not validate_uniqueness_of :#{col.name} }\r"
        @result += "      it { should_not have_db_index(:#{col.name}).unique(true) }\r" unless col.attr_accessor
      end
    end
    @result += "    end\r\r"
  end

  def model_length_test
    @result += "    context 'Length' do\r"
    @result += "      subject { create(:#{@model_test.name.underscore.singularize}) }\r\r"

    @model_test.model_columns.each do |col|
      if col.data_type.in? %w[decimal float]
        @result += "      it { should validate_format_of(:#{col.name}).with(#{'/^\d{1,' + col.max_length[0].to_s + '}(\.\d{0,' + col.max_length[1].to_s + '}})?$/'}) }\r" unless col.max_length.blank?
      elsif col.data_type.in? %w[integer]
        Rails.logger.debug '=' * 80
        Rails.logger.debug col.min_length
        min_range = col.min_length - 1 unless col.min_length.blank? || col.min_length < 1
        max_range = col.max_length + 1 unless col.max_length.blank? || col.max_length < 1
        @result += "      it { should_not allow_value(#{(1..min_range).to_a.join('')}).for(:#{col.name}) }\r" unless col.min_length < 1
        @result += "      it { should_not allow_value(#{(1..max_range).to_a.join('')}).for(:#{col.name}) }\r" unless col.max_length < 1
      else
        @result += "      it { should ensure_length_of(:#{col.name}).is_at_least(#{col.min_length}) }\r" unless col.min_length.blank?
        @result += "      it { should ensure_length_of(:#{col.name}).is_at_most(#{col.max_length}) }\r" unless col.max_length.blank?
      end

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

  # ====================================================
  #                Attribute Accessible
  # ====================================================
  def build_attr_accessible
    accessible = @model_test.model_columns.by_accessor(false)
    accessor = @model_test.model_columns.by_accessor(true)

    text = ''
    unless accessible.empty?
      text += '  # '+'='*11+' ATTRIBUTES ACCESSIBLE '+'='*10+"\n"

      text += '  attr_accessible '

      text += accessible.select { |col| col.mass_assign }.map { |col| ":#{col.name}" }.join(', ')
    end

    unless accessor.empty?
      text += "\n\n"
      text += '  # '+'='*11+' ATTRIBUTES ACCESSOR '+'='*11+"\n"

      text += '  attr_accessor '

      text += accessor.map { |col| ":#{col.name}" }.join(', ')
    end
    text += "\n\n"

    text
  end

  # ====================================================
  #                    Full Model
  # ====================================================
  def build_full_model
    text = ''
    text += "class #{@model_test.name} < ActiveRecord::Base"
    text += "\r\r"
    text += build_attr_accessible
    text += build_model_associations
    text += build_model_constants
    text += build_model_scopes
    text += build_model_validations
    text+= build_model_private_methods
    text += 'end'
  end

  # ====================================================
  #                Model Associations
  # ====================================================
  def build_model_associations
    text = ''
    text += '  # '+'='*15+' ASSOCIATIONS '+'='*15+"\n"
    @model_test.model_associations.each do |asc|
      text += "  #{asc.model_name} :#{asc.model_relationship_name} \r"
    end

    text += "\r\r"
  end

  # ====================================================
  #                Model Validations
  # ====================================================

  def build_model_validations
    text = ''
    text += '  # '+'='*16+' VALIDATIONS '+'='*15+"\n"
    @model_test.model_columns.each do |col|
      if col.unique || col.required || !col.min_length.blank? || !col.max_length.blank? || (col.data_type.in? %w[decimal float integer])
        text += "  validates :#{col.name}"
        if col.required
          if col.data_type == 'boolean'
            text += ', :acceptance => true'
          else
            text += ', :presence => true'
          end
        end

        #:uniqueness => {:scope => [test, something]}
        if col.unique
          if col.unique_scope.count < 1
            text += ',
            :uniqueness => true'
          else
            text += ",
            :uniqueness => {:scope => [#{col.unique_scope.map { |s| ":#{s}" }.join(', ')}]}"
          end
        end
        if col.data_type.in? %w[decimal float]
          unless col.max_length.blank?
            text += ',
            :format => { :with => /^\d{1,' + col.max_length[0].to_s + '}(\.\d{0,' + col.max_length[1].to_s + '})?$/ }'
          end
        else
          unless col.min_length.blank? && col.max_length.blank?
            text += ',
            :length => {'
            unless col.min_length.blank?
              text += ":minimum => #{col.min_length}"
              text += ', ' unless col.max_length.blank?
            end
            text += ":maximum => #{col.max_length}" unless col.max_length.blank?
            text += '}'
          end
        end

        text += ',
            :numericality => true' if col.data_type.in? %w[decimal float integer]
        text += "\r"
      end
    end
    text += "\r"
    text
  end

  # ====================================================
  #                    Model Scopes
  # ====================================================

  def build_model_scopes
    text = ''
    text += '  # '+'='*18+' SCOPES '+'='*18+"\r\r\r"
    text
  end

  # ====================================================
  #                    Model Constants
  # ====================================================

  def build_model_constants
    text = ''
    text += '  # '+'='*17+' CONSTANTS '+'='*16+"\r\r\r"
    text
  end

  # ====================================================
  #                Model Private Methods
  # ====================================================

  def build_model_private_methods
    text = ''
    text += "\r\r"
    text += '  # '+'='*14+' PRIVATE METHODS '+'='*13+"\r"
    text += '  private'
    text += "\r\r\r"
    text
  end

  # ====================================================
  #                     Migrations
  # ====================================================

  def build_migrations
    columns = @model_test.model_columns.by_accessor(false)

    text = ''
    text += "class Create#{@model_test.name.pluralize} < ActiveRecord::Migration\r"
    text += "  def change\r"
    text += "    create_table :#{@model_test.name.tableize} do |t|\r"
    columns.each do |col|
      col.name.gsub('_id', '') if col.data_type == 'references'
      text += "      t.#{col.data_type} :#{col.name}"
      text += ', :null => false' if col.required
      if col.max_length
        if col.data_type == 'decimal' || col.data_type == 'float'
          text += ", :precision => #{col.max_length[0]}, :scale => #{col.max_length[1]}" unless col.max_length.blank?
        else
          text += ", :limit => #{col.max_length}" unless col.max_length.blank?
        end
      end
      text += "\r"
    end
    text += "\r"
    text += "    t.timestamps\r" if @model_test.timestamps
    text += "    end\r"


    columns.each do |col|

      if col.unique
        if col.unique_scope.count < 1
          text += "  add_index :#{@model_test.name.tableize}, :#{col.name}, :unique => true\r"
        else
          text += "  add_index :#{@model_test.name.tableize}, [:#{col.name}, #{col.unique_scope.map { |s| ":#{s}" }.join(', ')}], :unique => true, :name => '#{@model_test.name.tableize}_unique_#{col.name}'\r"
        end
      elsif col.db_index
        text += "  add_index :#{@model_test.name.tableize}, :#{col.name}\r"
      end

    end
    text += "  end\r"
    text += "end\r"
    text
  end

  # ====================================================
  #                     Factory
  # ====================================================

  def build_model_factory
    text = ''
    text += "# Read about factories at http://github.com/thoughtbot/factory_girl\r"
    text += "FactoryGirl.define do\r"
    text += "  factory :#{@model_test.name.underscore.singularize} do\r"
    @model_test.model_columns.each do |col|

      case col.data_type
        when 'boolean'
          text += "    #{col.name} true\r"
        when 'date'
          text += "    #{col.name} Date.today\r"
        when 'datetime'
          text += "    #{col.name} Time.now\r"
        when 'decimal'
          text += "    #{col.name} 1.0\r"
        when 'float'
          text += "    #{col.name} 1.0\r"
        when 'integer'
          text += "    #{col.name} 1\r"
        when 'primary_key'
          text += "    #{col.name} 1\r"
        when 'references'
          text += "    #{col.name} 1\r"
        when 'string'
          text += "    #{col.name} Faker::Lorem.word\r"
        when 'text'
          text += "    #{col.name} Faker::Lorem.paragraph\r"
        when 'time'
          text += "    #{col.name} Time.now\r"
        when 'timestamp'
          text += "    #{col.name} Time.now\r"
      end
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
