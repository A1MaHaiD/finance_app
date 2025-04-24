require "test_helper"

class CategoryTest < ActiveSupport::TestCase

  def setup
    @user = users(:user_one)
    @category_sixth = categories(:cat_6)
    @category_first = categories(:cat_1)
  end

  # Category :name

  test "check the '1st_Category' from database" do
    # When
    category_first = categories(:cat_1)
    # Then
    assert_equal "1st_Category",
                 category_first.name,
                 "Ім'я категорії з фікстури не співпадає"
  end

  test "return false if name is missed and error message is added" do
    new_category = Category.new(description: "some description", user: @user)
    assert_not new_category.valid?, "Категорія пройшла валідацію, незважаючи на пусте значення name"
    assert_includes new_category.errors[:name],
                    "can't be blank",
                    "Відсутнє повідомлення про відсутність name"
  end

  test "should not allow duplicate category name for same user" do
    dup_category = @category_first.dup
    assert_not dup_category.valid?, "Задубльована категорія пройшла валідацію"
    assert_includes dup_category.errors[:name],
                    "name must be unique within your account",
                    "Не виявлено помилку унікальності для name"
  end

  test "return true if everything is good" do
    # When
    category_new = Category.new(
      name: "new category",
      description: "new description",
      user: @user
    )
    # Then
    assert category_new.valid?, "Категорія не пройшла валідацію"
  end

  test "saving and gathering" do
    # When
    new_category = Category.new(
      name: "new category",
      description: "new description",
      user: @user
    )
    new_category.save!
    new_cat = Category.find_by(name: "new category")
    # Then
    assert_equal "new description", new_cat.description, "Опис не співпадає після збереження"
  end

  # Category :description

  test "check the '6th Category' description" do
    # When
    category_sixth = categories(:cat_6)
    # Then
    assert_equal "6th description",
                 category_sixth.description,
                 "Опис фікстури '6th Category' не співпадає"
  end

  test "return false if description is missed" do
    # When
    category_new = Category.new(
      name: "new category", user: @user
    )
    # Then
    assert_not category_new.valid?,
               "Категорія була збережена, незважаючи на пусте значення description"
  end

  test "should be invalid without a user" do
    category_without_user = Category.new(name: "category without user", description: "some description")
    assert_not category_without_user.valid?, "Категорія є валідною без користувача"
    assert_includes category_without_user.errors[:user], "must exist",
                    "Відсутнє повідомлення для відсутності user"
  end
end

