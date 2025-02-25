class ReportsController < ApplicationController
  def index
  end

  def report_by_category
    @operations = Operation.where("category = ?", params[:category])
    # Логіка для формування звіту по категоріям
  end

  def report_by_dates
    @operations = Operation.where("date >= ? AND <= ?", params[:start_date], params[:end_date])
    # Логіка для формування звіту по датам
  end
end
