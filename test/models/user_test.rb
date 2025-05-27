require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
    @second_user = users(:user_two)
  end

  test "user fixture should be valid" do
    assert @user.valid?, "Очікується валідну фікстуру user"
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?, "User пройшов валідацію без email"
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save!
    assert_not duplicate_user.valid?, "Задубльований user пройшов валідацію"
  end

  test "user should require a valid password" do
    @user.password = @user.password_confirmation = "short"
    assert_not @user.valid?, "User пройшов валідацю з password коротше 6"
  end

  test "associated categories should be destroyed when user is destroyed" do
    user = User.create!(
      email: "newuser@example.com",
      password: "password",
      password_confirmation: "password"
    )
    user.categories.create!(name: "Test Category", description: "Category description")
    assert_difference "Category.count", -1 do
      user.destroy
    end
  end

  test "should have many operations through categories" do
    category = @user.categories.create!(name: "Sample Category", description: "Desc")
    operation = category.operations.create!(
      amount: 10.99,
      operation_type: "Доходи",
      odate: Date.today,
      description: "Test operation"
    )
    assert_includes @user.operations, operation,
                    "Операція має бути пов'язаною з користувачем через категорії"
  end

  test "should have default mailer sender set correctly" do
    assert_equal "from@example.com", ApplicationMailer.default[:from]
  end
end
