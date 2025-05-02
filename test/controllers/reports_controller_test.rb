require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:user_one)
    sign_in(@user)
    @valid_start_date = "2025-02-01"
    @valid_end_date = "2025-03-01"
  end

  test "should get index and display categories" do
    get reports_index_url
    assert_response :success
    assert_select "select[name='category']" do |elements|
      assert elements.any?, "Expected at least one category option to be present"
    end
  end

  test "report_by_category without dates redirects back with alert" do
    get reports_report_by_category_url, params: { operation_type: "Витрати" }
    assert_redirected_to reports_path
    assert_equal "Будь ласка, заповніть поля початкової та кінцевої дати.", flash[:alert]
  end

  test "report_by_category with valid dates returns success" do
    get reports_report_by_category_url, params: {
      start_date: @valid_start_date,
      end_date: @valid_end_date,
      operation_type: "Витрати"
    }
    assert_response :success
    assert_match /1st_Category/, @response.body
  end

  test "report_by_dates without dates redirects back with alert" do
    get reports_report_by_dates_url, params: { operation_type: "Витрати", category: 1 }
    assert_redirected_to reports_path
    assert_equal "Будь ласка, заповніть поля початкової та кінцевої дати.", flash[:alert]
  end

  test "report_by_dates without category redirects back with alert" do
    get reports_report_by_dates_url, params: {
      start_date: @valid_start_date,
      end_date: @valid_end_date,
      operation_type: "Витрати",
      category: ""
    }
    assert_redirected_to reports_path
    assert_equal "Будь ласка, виберіть категорію.", flash[:alert]
  end

  test "report_by_dates with valid parameters returns success" do
    category_id = categories(:cat_1).id
    get reports_report_by_dates_url, params: {
      start_date: "2025-01-01",
      end_date: "2025-12-31",
      operation_type: "Витрати",
      category: category_id
    }
    assert_response :success
    assert_match /\d{2}-\d{2}-\d{4}/, @response.body
  end
end
