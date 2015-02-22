require 'test_helper'

class EntityTermsControllerTest < ActionController::TestCase
  setup do
    @entity_term = entity_terms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:entity_terms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create entity_term" do
    assert_difference('EntityTerm.count') do
      post :create, entity_term: {  }
    end

    assert_redirected_to entity_term_path(assigns(:entity_term))
  end

  test "should show entity_term" do
    get :show, id: @entity_term
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @entity_term
    assert_response :success
  end

  test "should update entity_term" do
    put :update, id: @entity_term, entity_term: {  }
    assert_redirected_to entity_term_path(assigns(:entity_term))
  end

  test "should destroy entity_term" do
    assert_difference('EntityTerm.count', -1) do
      delete :destroy, id: @entity_term
    end

    assert_redirected_to entity_terms_path
  end
end
