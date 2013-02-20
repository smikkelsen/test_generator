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
      @result = "<h3>Rspec Tests</h3><textarea style='width:98%; height:200px'>"
      build_model_tests
      @result += "</textarea>"
      @result = @result.html_safe
    end

  end

  # POST /model_tests
  def create
    @model_test = ModelTest.new(params[:model_test])

    if @model_test.save
      if @role == "dev"
        redirect_to action: "edit"
      else
        redirect_to project_path(@model_test.project_id)
      end
    else
      render action: "new"
    end
  end

  # PUT /model_tests/1
  def update
    @model_test = ModelTest.find(params[:id])
    @model_test.update_attributes(params[:model_test])
    inspect_obj "model_test", @model_test.model_associations
    if @role == "dev"
      redirect_to action: "edit"
    else
      redirect_to project_path(@model_test.project_id)
    end
  end

  # DELETE /model_tests/1
  def destroy
    @model_test = ModelTest.find(params[:id])
    @model_test.destroy

    #set_message "Successfully Destroyed"
    redirect_to root_path
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
    @model_test.model_columns.each do |col|
      col.name = col.name.tableize.singularize unless ModelColumn.plural_exception?(col.name)
    end

    @model_test.name = @model_test.name.titleize.singularize
    @result = "" if @result.nil?
    @result += "describe #{@model_test.name} do\r\r"
    model_mass_assign_test
    model_indexes_test
    model_associations_test
    @result += "  context \"Validations\" do\r\r"
    model_presence_test
    model_length_test
    model_uniqueness_test
    @result += "  end\r\r"
    @result += "end"
  end

  def model_associations_test
    @result += "  context \"Associations\" do\r"
    @model_test.model_associations.each do |asc|
      related_table = ModelTest.find_by_id(asc.related_model_test_id)
      related_table_name = related_table.name
      case asc.relationship_type
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
      related_table_name = tb.downcase
      @result += "    it { should #{asc.relationship_type} :#{related_table_name} }\r"
    end

    @result += "  end\r\r"
  end

  def model_mass_assign_test
    @result += "  context \"Mass Assignment\" do\r"
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
    @result += "  context \"Indexes\" do\r"
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
    @result += "    context \"Presence\" do\r"
    @model_test.model_columns.each do |col|
      unless col.required == "no"
        @result += "      it { should validate_#{col.required} :#{col.name} }\r"
      end
    end
    @result += "    end\r\r"
  end

  def model_uniqueness_test
    @result += "    context \"Uniqueness\" do\r"
    @model_test.model_columns.each do |col|
      @result += "      it { should validate_uniqueness_of :#{col.name} }\r" if col.unique
    end
    @result += "    end\r\r"
  end

  def model_length_test
    @result += "    context \"Length\" do\r"
    @model_test.model_columns.each do |col|
      @result += "      it { should ensure_length_of(:#{col.name}).is_at_least(#{col.min_length}) }\r" if col.min_length
      @result += "      it { should ensure_length_of(:#{col.name}).is_at_most(#{col.max_length}) }\r" if col.max_length
    end
    @result += "    end\r\r"
  end

  ## ====================================================
  ##                Model Methods
  ## ====================================================
  #def build_model
  #  @model_test.model_columns.each do |col|
  #    col.name = col.name.tableize.singularize unless ModelColumn.plural_exception?(col.name)
  #  end
  #
  #  @model_test.name = @model_test.name.titleize.singularize
  #  @result = "" if @result.nil?
  #  @result += "class ModelTest < ActiveRecord::Base #{@model_test.name} do\r\r"
  #  model_mass_assign
  #  model_indexes
  #  model_associations
  #  @result += "  context \"Validations\" do\r\r"
  #  model_presence
  #  model_length
  #  model_uniqueness
  #  @result += "  end\r\r"
  #  @result += "end"
  #end
  #
  #def model_associations
  #  @result += "  context \"Associations\" do\r"
  #  @model_test.model_associations.each do |asc|
  #    case asc.type
  #      when "have_one"
  #        tb = asc.related_table.singularize
  #      when "have_many"
  #        tb = asc.related_table.pluralize
  #      when "have_and_belong_to_many"
  #        tb = asc.related_table.pluralize
  #      when "belong_to"
  #        tb = asc.related_table.singularize
  #      else
  #        tb = asc.related_table.singularize
  #    end
  #    asc.related_table = tb.downcase
  #    @result += "    it { should #{asc.type} :#{asc.related_table} }\r"
  #  end
  #
  #  @result += "  end\r\r"
  #end
  #
  #def model_mass_assign
  #  @result += "  context \"Mass Assignment\" do\r"
  #  @model_test.model_columns.each do |col|
  #    @result += "    it { should allow_mass_assignment_of :#{col.name} }\r" if col.mass_assign
  #  end
  #  @result += "  end\r\r"
  #end
  #
  #def model_indexes
  #  @result += "  context \"Indexes\" do\r"
  #  @model_test.model_columns.each do |col|
  #    @result += "    it { should have_db_index :#{col.name} }\r" if col.db_index
  #  end
  #  @result += "  end\r\r"
  #end
  #
  #def model_presence
  #  @result += "    context \"Presence\" do\r"
  #  @model_test.model_columns.each do |col|
  #    unless col.required == "no"
  #      @result += "      it { should validate_#{col.required} :#{col.name} }\r"
  #    end
  #  end
  #  @result += "    end\r\r"
  #end
  #
  #def model_uniqueness
  #  @result += "    context \"Uniqueness\" do\r"
  #  @model_test.model_columns.each do |col|
  #    @result += "      it { should validate_uniqueness_of :#{col.name} }\r" if col.unique
  #  end
  #  @result += "    end\r\r"
  #end
  #
  #def model_length
  #  @result += "    context \"Length\" do\r"
  #  @model_test.model_columns.each do |col|
  #    @result += "      it { should ensure_length_of(:#{col.name}).is_at_least(#{col.min_length}) }\r" if col.min_length
  #    @result += "      it { should ensure_length_of(:#{col.name}).is_at_most(#{col.max_length}) }\r" if col.max_length
  #  end
  #  @result += "    end\r\r"
  #end

end
