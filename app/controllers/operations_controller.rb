class OperationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :category, find_by: :id
  load_and_authorize_resource :operation, through: :category, shallow: true

  before_action :get_category, except: %i[all_operations]
  before_action :set_operation, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[new edit create update]

  # GET /operations or /operations.json
  def index
    @operations = @category.operations.page(params[:page])
  end

  # GET /all_operations
  def all_operations
    @operations = current_user.operations.page(params[:page])
    @category = current_user.categories.first # Задаємо значення @category для використання в представленні
  end

  # GET /operations/1 or /operations/1.json
  def show
  end

  # GET /operations/new
  def new
    @operation = @category.operations.build
  end

  # GET /operations/1/edit
  def edit
  end

  # POST /operations or /operations.json
  def create
    logger.debug "Параметри операції: #{operation_params.inspect}"
    logger.debug "Категорії користувача: #{current_user.categories.pluck(:id)}"
    @operation = @category.operations.build(operation_params)
    # @operation.category_id = current_user.categories.find(params[:operation][:category_id])

    respond_to do |format|
      if @operation.save
        format.html { redirect_to category_operations_path(@operation.category), notice: "Транзакція успішно збережена." }
        format.json { render :show, status: :created, location: @operation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /operations/1 or /operations/1.json
  def update
    respond_to do |format|
      if @operation.update(operation_params)
        format.html { redirect_to category_operations_path(@category), notice: "Транзакція успішно оновлена." }
        format.json { render :show, status: :ok, location: @operation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operations/1 or /operations/1.json
  def destroy
    @operation.destroy
    respond_to do |format|
      format.html { redirect_to category_operations_path(@category), notice: "Транзакція успішно видалена." }
      format.json { head :no_content }
    end
  end

  private

  def get_category
    @category = current_user.categories.find(params[:category_id])
    unless @category
      redirect_to categories_path, alert: "Категорія не знайдена або ви не маєте доступу."
    end
  end

  def set_operation
    @operation = @category.operations.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:alert] = e.message == "Couldn't find Operation" ? "Транзакція не знайдена." : "Ви не маєте доступу до цієї операції."
    redirect_to category_operations_path(@category)
  end

  def set_categories
    @categories = current_user.categories.all.map { |c| [ c.name, c.id ] }
  end

  def operation_params
    params.require(:operation).permit(:amount, :operation_type, :odate, :description, :category_id)
  end
end
