class Admin::CategoriesController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @supports = Supports::CategorySupport.new category: Category.new
    @categories = Category.search(search_params).result.hash_tree
  end

  def create
    if params[:parent_id].to_i > 0
      parent = Category.find_by id: params[:parent_id]
      @category = parent.children.build categpry_params
    end
    if @category.save
      flash[:success] = t "flash.categories.add_category_success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "flash.categories.cant_add_category"
    end
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "flash.categories.edit_category_success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "flash.categories.cant_edit_category"
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "flash.categories.delete_category_success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "flash.categories.category_cant_delete"
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = t "flash.find_category_fail"
    redirect_to admin_categories_path
  end

  private
  def search_params
    params.permit :name_cont
  end

  def category_params
    params.require(:category).permit :name, :parent_id
  end
end
