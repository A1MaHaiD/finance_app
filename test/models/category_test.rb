require "test_helper"

class CategoryTest < ActiveSupport::TestCase

  # Category :name

  test "check the '1s_Category' from database" do
    # When
    category_first = Category.find_by(name: "1st_Category")
    # Then
    assert_equal("1st_Category", category_first.name)
  end

  test "return false if name is missed" do
    # When
    new_category = Category.new(description: "some description")
    # Then
    assert_not(new_category.valid?)
  end

  test "return true if everything is good" do
    # When
    category_new = Category.new(name: "new category", description: "new description")
    # Then
    assert(category_new.valid?)
  end

  test "saving and gathering" do
    # When
    new_category = Category.new(name: "new category", description: "new description")
    new_category.save()
    new_cat = Category.find_by(name: "new category")
    # Then
    assert_equal("new description", new_cat.description)
  end

  # Category :description

  test "check the '6th Category' description" do
    # When
    category_sixth = Category.find_by(name: "6th Category")
    # Then
    assert_equal("6th description", category_sixth.description)
  end

  test "return false if description is missed" do
    # When
    category_new = Category.new(name: "new category")
    # Then
    assert_not(category_new.valid?)
  end
end

