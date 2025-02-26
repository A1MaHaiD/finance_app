class ReportsController < ApplicationController
  def index
  end

  def report_by_category
    # @operations = Operation.where("category = ?", params[:category])
    # Логіка для формування звіту по категоріям
    report_by_category = Operation.all.map { |report| [report.amount, report.category_id.to_s] }
    @amounts = report_by_category.map { |r| r[0]}
    @category_id = report_by_category.map { |r| r[1] }
  end

  def report_by_dates
    # @operations = Operation.where("date >= ? AND <= ?", params[:start_date], params[:end_date])
    # Логіка для формування звіту по датам
    report_by_dates = Operation.all.map { |report| [report.amount, report.odate.to_s] }
    @amounts = report_by_dates.map { |r| r[0]}
    @odates = report_by_dates.map { |r| r[1] }
  end
end
