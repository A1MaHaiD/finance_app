class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = current_user.categories.all.pluck(:name, :id, :user_id)
  end

  def report_by_category
    if params[:start_date].blank? || params[:end_date].blank?
      flash[:alert] = "Будь ласка, заповніть поля початкової та кінцевої дати."
      redirect_to reports_path and return
    end
    # Логіка для формування звіту по категоріям
    @report_by_category = current_user.operations.joins(:category)
                                      .where('odate BETWEEN ? AND ?', params[:start_date], params[:end_date])
                                      .where(operation_type: params[:operation_type])
                                      .group('categories.name')
                                      .sum(:amount)
    @names = @report_by_category.keys
    @sums = @report_by_category.values
  end

  def report_by_dates
    if params[:start_date].blank? || params[:end_date].blank?
      flash[:alert] = "Будь ласка, заповніть поля початкової та кінцевої дати."
      redirect_to reports_path and return
    end
    if params[:category].blank?
      flash[:alert] = "Будь ласка, виберіть категорію."
      redirect_to reports_path and return
    end
    # Логіка для формування звіту по датам
    @report_by_dates = current_user.operations.joins(:category)
                                   .where('odate BETWEEN ? AND ?', params[:start_date], params[:end_date])
                                   .where(operation_type: params[:operation_type])
                                   .where(categories: { id: params[:category] })
                                   .group("odate")
                                   .sum(:amount)
    @odates = @report_by_dates.keys.map { |date| date.strftime("%d-%m-%Y") }
    @amounts = @report_by_dates.values
    @categories = { id: params[:category], name: Category.find(params[:category]).name }
  end
end
