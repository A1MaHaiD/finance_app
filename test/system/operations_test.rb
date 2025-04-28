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
    visit category_operations_url(@category)
    assert_selector "h1", text: "Транзакції"
  end

  test "should create operation" do
    visit category_operations_url(@category)
    assert_selector "a[data-test='new-operation']", visible: true
    find("a[data-test='new-operation']").click

    fill_in "operation_amount", with: @operation.amount
    fill_in "operation_description", with: @operation.description
    fill_in "operation_odate", with: @operation.odate
    select @operation.operation_type, from: "Тип операції"

    assert_selector "input[data-test='save-operation']", visible: true
    find("input[data-test='save-operation']").click
    assert_text "Транзакція успішно збережена."
  end

  test "should update Operation" do
    visit category_operations_url(@category)
    assert_selector "a[data-test='edit-operation']", visible: true, wait: 5
    find("a[data-test='edit-operation']", match: :first).click

    fill_in "operation_amount", with: @operation.amount
    fill_in "operation_description", with: @operation.description
    fill_in "operation_odate", with: @operation.odate.to_s
    select @operation.operation_type, from: "Тип операції"

    assert_selector "input[data-test='save-operation']", visible: true
    find("input[data-test='save-operation']").click

    assert_text "Транзакція успішно оновлена."
  end

  test "should destroy Operation" do
    visit category_operations_url(@category)
    assert_selector "button[data-test='destroy-operation']", visible: true
    find("button[data-test='destroy-operation']").click

    assert_text "Транзакція успішно видалена."
  end
end
