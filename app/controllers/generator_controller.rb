class GeneratorController < ApplicationController

  def choose
    @model_tests = ModelTest.find_all_by_ip_address(request.remote_ip)

    render 'generator/choose'
  end

  def model
    if params['submit']
      @model = ModelTest.new(params[:model])
      @result = "<textarea style='width:100%; height:500px;'>"
      build_model_test
      @result += "</textarea>"

      @result = @result.html_safe

      @model.save!
    else
      @model = ModelTest.new
      @model.ip_address=request.remote_ip
      @model.columns.build
      @model.associations.build
    end
    render 'generator/model'
  end

  def controller

    render 'generator/controller'
  end


end