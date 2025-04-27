require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    @user_2 = users(:user_two)
    sign_in @user
    @category = categories(:cat_1)
    @category_2 = categories(:cat_2)
  end

  test "visiting the index" do
    visit categories_url
    assert_selector "h1", text: "Категорії"
  end

  test "should create category" do
    visit categories_url
    assert_selector "a[data-test='new-category']", visible: :all
    find("a[data-test='new-category']").click

    fill_in "category_name", with: @category_2.name
    fill_in "category_description", with: @category_2.description
    assert_selector "input[data-test='save-category']", visible: :all
    find("input[data-test='save-category']").click

    assert_text "Категорія була успішно створена."
    assert_selector "a[data-test='back-to-categories']", visible: :all
    find("a[data-test='back-to-categories']").click
  end

  test "should update Category" do
    visit category_url(@category)
    assert_selector "a[data-test='edit-category']", visible: :all, wait: 5
    find("a[data-test='edit-category']").click

    fill_in "category_name", with: @category.name
    fill_in "category_description", with: @category.description
    assert_selector "input[data-test='save-category']", visible: :all
    find("input[data-test='save-category']").click

    assert_text "Категорія успішно оновлена."
    assert_selector "a[data-test='back-to-categories']", visible: :all
    find("a[data-test='back-to-categories']").click
  end

  test "should destroy Category" do
    visit category_url(@category)
    assert_selector "button[data-test='destroy-category']", visible: :all
    find("button[data-test='destroy-category']").click

    assert_text "Категорія успішно видалена."
  end
end
