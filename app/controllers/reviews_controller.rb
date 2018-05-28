class ReviewsController < ApplicationController
  load_resource :tour
  load_and_authorize_resource :review, through: :tour, shallow: :true

  before_action :authenticate_user!
  before_action :load_review_types, only: [:new, :create, :edit]

  def create
    @review.user = current_user
    if @review.save
      flash[:success] = t "flash.reviews.create_review_success"
      redirect_to tour_review_path(@tour, @review)
    else
      render :new
    end
  end

  def show
    @supports = Supports::ReviewSupport.new review: @review,
      page: params[:page], user: current_user
  end

  def index
    @reviews = current_user.reviews
      .order_time_desc.paginate page: params[:page],
      per_page: Settings.reviews.per_page_reviews
  end

  def edit
  end

  def update
    if @review.update_attributes review_params
      @supports = Supports::ReviewSupport.new review: @review,
        page: params[:page], user: current_user
      flash[:success] = t "flash.reviews.review_updated"
    else
      flash[:danger] = t "flash.reviews.booking_update_fail"
    end
    render :show
  end

  def destroy
    if @review.destroy
      flash[:success] = t "flash.review.review_deleted"
    else
      flash[:danger] = t "flash.reviews.review_delete_fail"
    end
    redirect_to root_path
  end

  rescue_from ActiveRecord::RecordNotFound do
    if @tour.nil?
      flash[:danger] = t "flash.tours.tour_not_found"
      redirect_to root_path
    else
      flash[:danger] = t "flash.reviews.review_not_found"
      redirect_to @tour
    end
  end

  private
  def review_params
    params.require(:review).permit :review_type, :title, :content
  end

  def load_review_types
    @review_types = Review.review_types.map {|key, value| [key, key]}
  end
end
