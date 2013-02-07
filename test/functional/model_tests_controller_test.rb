require 'test_helper'

class ModelTestsControllerTest < ActionController::TestCase
  setup do
    @model_test = model_tests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:model_tests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create model_test" do
    assert_difference('ModelTest.count') do
      post :create, model_test: { ip_address: @model_test.ip_address, name: @model_test.name }
    end

    assert_redirected_to model_test_path(assigns(:model_test))
  end

  test "should show model_test" do
    get :show_dev, id: @model_test
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @model_test
    assert_response :success
  end

  test "should update model_test" do
    put :update, id: @model_test, model_test: { ip_address: @model_test.ip_address, name: @model_test.name }
    assert_redirected_to model_test_path(assigns(:model_test))
  end

  test "should destroy model_test" do
    assert_difference('ModelTest.count', -1) do
      delete :destroy, id: @model_test
    end

    assert_redirected_to model_tests_path
  end
end
