class ProjectsController < ApplicationController

  before_filter :force_role, :except => [:set_role]
# Root URL
  def set_role
    if params['role']
      cookies['role'] = {
          :value => params['role'],
          :expires => Time.now + 30.days
      }
    end
    @role = cookies['role']

    if @role == 'dev' || @role == 'pm'
      redirect_to :action => :index
    else
      render '/application/choose_role'
    end
  end

  # GET /projects
  def index
    @projects = Project.find_all_by_ip_address(request.remote_ip)
  end

  # GET /projects/1
  def show
    @project = Project.find(params[:id])
    @title = @project.name
    @model_tests = ModelTest.find_all_by_project_id(@project.id).sort_by!(&:name)

    if @role == 'dev'
      render 'show_dev'
    else
      render 'show_pm'
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.ip_address=request.remote_ip
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    @title = @project.name
  end

  # POST /projects
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  protected

  def force_role
    @role = cookies['role']

    unless @role
      redirect_to :action => :set_role
    end
  end
end
