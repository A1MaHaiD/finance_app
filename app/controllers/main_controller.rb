class MainController < ApplicationController
  before_action :authenticate_user!

  def index
    begin
      check_database_and_redirect
    rescue StandardError => e
      redirect_to root_path, alert: "Виникла проблема: #{e.message}"
    end
  end

  private

  def check_database_and_redirect
    if current_user.categories.none?
      # Якщо категорій немає, перенаправляємо на створення категорій
      redirect_to categories_path, alert: "Додайте хоча б одну категорію, щоб продовжити."
      Rails.logger.info "Current user categories: #{current_user.categories.count}"
    elsif current_user.operations.none?
      Rails.logger.info "Current user categories: #{current_user.categories.count}"
      # Якщо операцій немає, перенаправляємо на операції першої категорії
      if current_user.categories.exists?
        redirect_to category_operations_path(current_user.categories.first), alert: "Додайте хоча б одну операцію, щоб продовжити."
        Rails.logger.info "Current user operations: #{current_user.operations.count}"
      else
        redirect_to categories_path, alert: "Створіть хоча б одну категорію."
      end
    else
      # Якщо все є, переходимо до звітів
      redirect_to reports_path, notice: "Ласкаво просимо до генератора звітів!"
      Rails.logger.info "Current user categories: #{current_user.categories.count}"
      Rails.logger.info "Current user operations: #{current_user.operations.count}"
    end
  rescue StandardError => e
    # Обробка будь-яких несподіваних помилок
    redirect_to root_path, alert: "Виникла проблема: #{e.message}"
  end
end
