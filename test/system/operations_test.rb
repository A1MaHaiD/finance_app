require "application_system_test_case"

class OperationsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_one)
    sign_in @user
    @category = categories(:cat_1)
    @operation = operations(:op_1)
  end

  test "visiting the index" do
    visit category_operations_url
    assert_selector "h1", text: "Operations"
  end

  test "should create operation" do
    visit category_operations_url
    click_on "New operation"

    fill_in "Amount", with: @operation.amount
    fill_in "Category", with: @operation.category_id
    fill_in "Description", with: @operation.description
    fill_in "Odate", with: @operation.odate
    fill_in "Operation type", with: @operation.operation_type
    click_on "Create Operation"

    assert_text "Operation was successfully created"
    click_on "Back"
  end

  test "should update Operation" do
    visit category_operations_url(@operation)
    click_on "Edit this operation", match: :first

    fill_in "Amount", with: @operation.amount
    fill_in "Category", with: @operation.category_id
    fill_in "Description", with: @operation.description
    fill_in "Odate", with: @operation.odate.to_s
    fill_in "Operation type", with: @operation.operation_type
    click_on "Update Operation"

    assert_text "Operation was successfully updated"
    click_on "Back"
  end

  test "should destroy Operation" do
    visit category_operations_url(@operation)
    click_on "Destroy this operation", match: :first

    assert_text "Operation was successfully destroyed"
  end
end
