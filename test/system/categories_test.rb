require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:user_one)
    sign_in @user
    @category = categories(:cat_1)
  end

  test "visiting the index" do
    visit categories_url
    assert_selector "h1", text: "Категорії"
  end

  test "should create category" do
    visit categories_url
    find("a[data-test='new-category']").click

    fill_in "Description", with: @category.description
    fill_in "Name", with: @category.name
    click_on "Create Category"

    assert_text "Категорія була успішно створена."
    find("a[data-test='back-to-categories']").click
  end

  test "should update Category" do
    visit category_url(@category)
    find("a[data-test='edit-category']").click

    fill_in "Description", with: @category.description
    fill_in "Name", with: @category.name
    click_on "Update Category"

    assert_text "Категорія успішно оновлена."
    find("a[data-test='back-to-categories']").click
  end

  test "should destroy Category" do
    visit category_url(@category)
    find("a[data-test='destroy-category']").click

    assert_text "Категорія успішно видалена."
  end
end
