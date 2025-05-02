class CategoriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_category, only: %i[show edit update destroy]

  # GET /categories or /categories.json
  def index
    @categories = current_user.categories.page(params[:page])
  end

  # GET /categories/1 or /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @category = current_user.categories.build(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: "Категорія була успішно створена." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: "Категорія успішно оновлена." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    respond_to do |format|
      if @category.destroy
        format.html { redirect_to categories_path, status: :see_other, notice: "Категорія успішно видалена." }
        format.json { head :no_content }
      else
        format.html { redirect_to @category, alert: @category.errors.full_messages.join(". ") }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to categories_path, alert: "Ви не маєте доступу до цієї категорії."
  end

  def category_params
    params.require(:category).permit(:name, :description, :user_id)
  end
end
