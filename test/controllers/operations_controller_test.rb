require "test_helper"

class OperationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:user_one)
    sign_in @user
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

  test "should not create operation without amount" do
    assert_no_difference("Operation.count") do
      post category_operations_url(@category), params: {
        operation: {
          amount: nil,
          category_id: @operation.category_id,
          description: @operation.description,
          odate: @operation.odate,
          operation_type: @operation.operation_type
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create operation without operation_type" do
    assert_no_difference("Operation.count") do
      post category_operations_url(@category), params: {
        operation: {
          amount: 10.0,
          category_id: @category.id,
          description: "Операція без типу",
          odate: Time.zone.now,
          operation_type: nil
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create operation for another user's category" do
    other_user_category = categories(:cat_2)

    assert_raises CanCan::AccessDenied do
      post category_operations_url(other_user_category), params: {
        operation: {
          amount: 10.0,
          category_id: other_user_category.id,
          description: "Невірна операція",
          odate: Time.zone.now,
          operation_type: "Витрати"
        }
      }
    end
  end

  test "should not update operation with invalid amount" do
    patch category_operation_url(@category, @operation), params: {
      operation: {
        amount: -5, # Некоректне значення
        description: @operation.description,
        odate: @operation.odate,
        operation_type: @operation.operation_type
      }
    }
    assert_response :unprocessable_entity
  end

  test "should only show operations belonging to user categories" do
    get category_operations_url(@category)
    assert_response :success
    assert_select "td", text: @operation.description
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

  test "should not delete non-existent operation" do
    assert_no_difference("Operation.count") do
      delete category_operation_url(@category, -1) # Невірний ID
    end
    assert_response :not_found
  end
end