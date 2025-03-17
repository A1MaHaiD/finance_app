class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = Category.all.pluck(:name, :id)
  end

  def report_by_category
    # Логіка для формування звіту по категоріям
    @report_by_category = Operation.joins(:category)
                                   .where('odate BETWEEN ? AND ?', params[:start_date], params[:end_date])
                                   .where(operation_type: params[:operation_type])
                                   .group('categories.name')
                                   .sum(:amount)
    @names = @report_by_category.keys
    @sums = @report_by_category.values
  end

  def report_by_dates
    # Логіка для формування звіту по датам
    @report_by_dates = Operation.joins(:category)
                                .where('odate BETWEEN ? AND ?', params[:start_date], params[:end_date])
                                .where(operation_type: params[:operation_type])
                                .group("odate")
                                .sum(:amount)
    @odates = @report_by_dates.keys.map(&:to_s)
    @amounts = @report_by_dates.values
  end
end
