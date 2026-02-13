require "test_helper"

class ImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get imports_new_url
    assert_response :success
  end

  test "should get create" do
    get imports_create_url
    assert_response :success
  end

  test "should get show" do
    get imports_show_url
    assert_response :success
  end

  test "should get confirm" do
    get imports_confirm_url
    assert_response :success
  end
end
