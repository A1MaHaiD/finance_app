require "test_helper"

class OperationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:cat_1)
    @operation = operations(:op_1)
  end

  test "should get index" do
    get category_operations_url(@category)
    assert_response :success
  end

  test "should get new" do
    get new_category_operation_url(@category)
    assert_response :success
  end

  test "should create operation" do
    assert_difference("Operation.count") do
      post category_operations_url(@category), params: {
        operation: {
          amount: @operation.amount,
          category_id: @operation.category_id,
          description: @operation.description,
          odate: @operation.odate,
          operation_type: @operation.operation_type
        } }
    end
    assert_redirected_to category_operations_url(@operation.category)
  end

  test "should show operation" do
    get category_operation_url(@category, @operation)
    assert_response :success
  end

  test "should get edit" do
    get edit_category_operation_url(@category, @operation)
    assert_response :success
  end

  test "should update operation" do
    patch category_operation_url(@category, @operation), params: {
      operation: {
        amount: @operation.amount,
        category_id: @operation.category_id,
        description: @operation.description,
        odate: @operation.odate,
        operation_type: @operation.operation_type
      } }
    assert_redirected_to category_operations_url(@category)
  end

  test "should destroy operation" do
    assert_difference("Operation.count", -1) do
      delete category_operation_url(@category, @operation)
    end
    assert_redirected_to category_operations_url(@category)
  end
end