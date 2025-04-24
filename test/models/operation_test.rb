require "test_helper"

class OperationTest < ActiveSupport::TestCase
  # Given
  def setup
    @category_sixth = categories(:cat_6)
    @category_first = categories(:cat_1)
  end

  test "return true if everything is good" do
    # When
    operation_new = Operation.new(
      amount: 1.09,
      operation_type: "Доходи",
      odate: Date.today,
      description: "Якийсь опис",
      category: @category_sixth)
    # Then
    assert operation_new.valid?
  end

  # Operation :amount

  test "check the amount '9.99' from database" do
    # Given
    amount_from_db = 9.99
    # When
    operation_find_amount = Operation.find_by(amount: amount_from_db)
    # Then
    assert_equal 9.99, operation_find_amount.amount
  end

  test "return false if amount is missed" do
    # When
    operation_new = Operation.new(
      operation_type: "Витрати",
      odate: Date.today,
      description: "Суму не ввели",
      category: @category_sixth)
    # Then
    assert_not(operation_new.valid?)
  end

  test "return false if amount is nil" do
    operation_new = Operation.new(
      amount: nil,
      operation_type: "Доходи",
      odate: Date.today,
      description: "Значення nil для суми",
      category: @category_sixth
    )
    assert_not operation_new.save, "Операція була збережена, незважаючи на nil значення для amount"
    assert_includes operation_new.errors[:amount], "can't be blank"
  end

  test "should not save operation with negative amount" do
    # When
    operation = Operation.new(
      amount: -1,
      operation_type: "Доходи",
      odate: Date.today,
      description: "Вартість нижче нуля",
      category: @category_sixth
    )
    # Then
    assert_not operation.save, "Операція була збережена, незважаючи на ввід '-1'"
    assert_includes operation.errors[:amount], "must be greater than 0",
                    "Помилка валідації amount відсутня"
  end

  test "check the zero validation input" do
    # When
    operation = Operation.new(
      amount: 0,
      operation_type: "Доходи",
      odate: Date.today,
      description: "Вартість рівна нулю",
      category: @category_sixth
    )
    # Then
    assert_not operation.save, "Операція була збережена, незважаючи на ввід '0'"
    assert_includes operation.errors[:amount], "must be greater than 0",
                    "Помилка валідації amount відсутня"
  end

  # Operation :operation_type

  test "check the operation_type 'Витрати' from database" do
    ot_from_db = "Витрати"
    # When
    operation_find_op = Operation.find_by(operation_type: ot_from_db)
    # Then
    assert_equal "Витрати", operation_find_op.operation_type
  end

  test "return false if operation_type is missed" do
    # When
    operation_new = Operation.new(
      amount: 1,
      odate: Date.today,
      description: "Не введено тип операції",
      category: @category_sixth)
    # Then
    assert_not operation_new.valid?
  end

  test "return false if operation_type is nil" do
    # When
    operation_new = Operation.new(
      amount: 2,
      operation_type: nil,
      odate: Date.today,
      description: "Значення nil для типу операції",
      category: @category_sixth
    )
    # Then
    assert_not operation_new.save, "Операція була збережена, незважаючи на nil значення для operation_type"
    assert_includes operation_new.errors[:operation_type], "can't be blank"
  end

  # Operation :odate
  test "check the odate '2025-02-22 20:40:42' from database" do
    # Given
    odate_from_db = DateTime.parse("2025-02-22 20:40:42")
    # When
    operation_find_od = Operation.find_by(odate: odate_from_db)
    # Then
    assert_equal odate_from_db, operation_find_od.odate
  end

  test "return false if odate is missed" do
    # When
    operation_new = Operation.new(
      amount: 1,
      operation_type: "Доходи",
      description: "Забули ввести дату",
      category: @category_sixth)
    # Then
    assert_not operation_new.valid?
  end

  test "return false if odate is nil" do
    # When
    operation_new = Operation.new(
      amount: 2,
      operation_type: "Доходи",
      odate: nil,
      description: "Значення дати nil для операції",
      category: @category_sixth
    )
    # Then
    assert_not operation_new.save, "Операція була збережена, незважаючи на nil значення для odate"
    assert_includes operation_new.errors[:odate], "can't be blank"
  end

  # Operation :description
  test "check the description 'Доходи % з депозитів' from database" do
    # Given
    description_from_db = "Доходи % з депозитів"
    # When
    operation_find_desc = Operation.find_by(description: description_from_db)
    # Then
    assert_equal "Доходи % з депозитів", operation_find_desc.description
  end

  test "return false if description is missed" do
    # When
    operation_new = Operation.new(
      amount: 1,
      operation_type: "Доходи",
      odate: Date.today,
      category: @category_sixth)
    # Then
    assert_not operation_new.valid?
  end

  test "return false if description is nil" do
    # When
    operation_new = Operation.new(
      amount: 2,
      operation_type: "Доходи",
      odate: Date.today,
      description: nil,
      category: @category_sixth
    )
    # Then
    assert_not operation_new.save, "Операція була збережена, незважаючи на nil значення для description"
    assert_includes operation_new.errors[:description], "can't be blank"
  end

  # Operation :category
  test "should not save operation without category" do
    operation = Operation.new(
      amount: 9.99,
      operation_type: "Витрати",
      odate: Date.today,
      description: "Витрати за надані послуги",
      category: nil
    )
    assert_not operation.save, "Операція була збережена без категорії"
    assert_includes operation.errors[:category], "must exist", "Помилка валідації category відсутня"
  end

  test "should save operation with category" do
    operation = Operation.new(
      amount: 9.99,
      operation_type: "Витрати",
      odate: Date.today,
      description: "Витрати за надані послуги",
      category: @category_first
    )
    assert operation.save, "Операція не була збережена з категорією"
  end

  test "should update operation description" do
    operation = operations(:op_1)
    new_description = "Оновлений опис"
    assert operation.update(description: new_description)
    assert_equal new_description, operation.reload.description
  end

  test "should delete operation when category is deleted" do
    category_temp = Category.create(
      name: "Temp_Category",
      description: "Тимчасова категорія",
      user: users(:user_one)
    )
    operation = Operation.create(
      amount: 9.99,
      operation_type: "Витрати",
      odate: Date.today,
      description: "Витрати за надані послуги",
      category: category_temp
    )
    assert_difference "Operation.count", -1 do
      category_temp.destroy_with_operations
    end
  end
end
