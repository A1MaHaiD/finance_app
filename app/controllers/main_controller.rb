class MainController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:firstname].present? && params[:lastname].present? && params[:password].present?
      # Користувач натиснув кнопку "Увійти", перевіряємо дані в базі
      check_database_and_redirect
    else
      # Звичайний виклик методу index до натискання кнопки
      render :index
    end
  end

  private

  def check_database_and_redirect
    if Category.none?
      redirect_to categories_path, alert: "Додайте хоча б одну категорію, щоб продовжити."
    elsif Operation.none?
      redirect_to category_operations_path(Category.first), alert: "Додайте хоча б одну операцію, щоб продовжити."
    else
      redirect_to reports_path, notice: "Ласкаво просимо до генератора звітів!"
    end
  end
end
