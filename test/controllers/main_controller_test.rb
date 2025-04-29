require "test_helper"

class MainControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  self.use_transactional_tests = true
  self.parallelize(workers: 1)

  setup do
    Warden.test_mode!
  end

  teardown do
    Warden.test_reset!
  end

  test "redirects to categories when user has no categories" do
    user = User.create!(
      email: "nocategories1_#{Time.now.to_i}@test.com",
      password: "password",
      password_confirmation: "password"
    )
    user = users(:user_one)
    user.categories.destroy_all
    sign_in user
    get main_index_url
    assert_redirected_to categories_path
    assert_equal "Додайте хоча б одну категорію, щоб продовжити.", flash[:alert]
  end

  test "redirects to first category operations when user has categories but no operations" do
    user = User.create!(
      email: "nocategories2_#{Time.now.to_i}@test.com",
      password: "password",
      password_confirmation: "password"
    )
    user = users(:user_one)
    user.categories.destroy_all
    category = user.categories.create!(
      name: "Test Category2",
      description: "Test Description2 "
    )
    sign_in user
    get main_index_url
    assert_redirected_to category_operations_path(category)
    assert_equal "Додайте хоча б одну операцію, щоб продовжити.", flash[:alert]
  end

  test "redirects to reports when user has categories and operations" do
    sign_in users(:user_one)
    get main_index_url
    assert_redirected_to reports_path
    assert_equal "Ласкаво просимо до генератора звітів!", flash[:notice]
  end

  test "handles unexpected errors gracefully" do
    sign_in users(:user_one)
    original_method = MainController.instance_method(:check_database_and_redirect)
    MainController.define_method(:check_database_and_redirect) { raise StandardError.new("Test error") }

    begin
      get main_index_url
      assert_redirected_to root_path
      assert_match /Виникла проблема:/, flash[:alert]
    ensure
      MainController.define_method(:check_database_and_redirect, original_method)
    end
  end
end
