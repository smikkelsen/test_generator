require 'test_helper'

class TesteronisControllerTest < ActionController::TestCase
  setup do
    @testeroni = testeronis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:testeronis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create testeroni" do
    assert_difference('Testeroni.count') do
      post :create, testeroni: {  }
    end

    assert_redirected_to testeroni_path(assigns(:testeroni))
  end

  test "should show testeroni" do
    get :show_dev, id: @testeroni
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @testeroni
    assert_response :success
  end

  test "should update testeroni" do
    put :update, id: @testeroni, testeroni: {  }
    assert_redirected_to testeroni_path(assigns(:testeroni))
  end

  test "should destroy testeroni" do
    assert_difference('Testeroni.count', -1) do
      delete :destroy, id: @testeroni
    end

    assert_redirected_to testeronis_path
  end
end
