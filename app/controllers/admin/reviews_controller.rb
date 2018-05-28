class Admin::ReviewsController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @reviews = Review.order_time_desc.paginate page: params[:page],
    per_page: Settings.reviews.admin_review_per_page
  end

  def show
  end

  def destroy
    if @review.destroy
      flash[:success] = t "flash.reviews.review_deleted"
      redirect_to admin_reviews_path
    else
      flash[:danger] = t "flash.reviews.review_cant_delete"
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = t "flash.find_review_fail"
    redirect_to admin_reviews_path
  end
end
