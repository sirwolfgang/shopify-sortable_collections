require 'test_helper'

class WebhooksControllerTest < ActionController::TestCase
  test "should get app_uninstalled" do
    get :app_uninstalled
    assert_response :success
  end

  test "should get shop_update" do
    get :shop_update
    assert_response :success
  end

  test "should get products_create" do
    get :products_create
    assert_response :success
  end

  test "should get products_update" do
    get :products_update
    assert_response :success
  end

  test "should get products_delete" do
    get :products_delete
    assert_response :success
  end

  test "should get collections_create" do
    get :collections_create
    assert_response :success
  end

  test "should get collections_update" do
    get :collections_update
    assert_response :success
  end

  test "should get collections_delete" do
    get :collections_delete
    assert_response :success
  end

end
