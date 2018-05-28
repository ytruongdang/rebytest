class Admin::ToursController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @supports = Supports::TourSupport.new tour: @tour
    @tours = Tour.distinct
      .price_between(params[:from_price], params[:to_price])
      .rating_order(params[:rating_rule]).price_order(params[:price_rule])
      .search(search_params).result.paginate page: params[:page],
      per_page: Settings.tours.tours_per_page
  end

  def new
    @tour.tour_dates.build
    @tour.tour_places.build
    @supports = Supports::TourSupport.new tour: @tour
  end

  def create
    if @tour.save
      flash[:success] = t "flash.tours.add_tour_success"
      redirect_to admin_tour_path @tour
    else
      @tour.tour_dates.build if @tour.tour_dates.empty?
      @tour.tour_places.build if @tour.tour_places.empty?
      @supports = Supports::TourSupport.new tour: @tour

      flash[:danger] = t "flash.tours.add_tour_fail"
      render :new
    end
  end

  def edit
    @supports = Supports::TourSupport.new tour: @tour
  end

  def update
    if @tour.update_attributes tour_params
      flash[:success] = t "flash.tours.update_success"
      respond_to do |format|
        format.html {redirect_to admin_tour_path @tour}
        format.js
      end
    else
      flash[:danger] = t "flash.tours.update_fail"
      respond_to do |format|
        format.html do
          @supports = Supports::TourSupport.new tour: @tour
          render :edit
        end
        format.js
      end
    end
  end

  def destroy
    if @tour.destroy
      flash[:success] = t "flash.tours.delete_tour_success"
      redirect_to admin_tours_path
    else
      flash[:danger] = t "flash.tours.delete_tour_fail"
      redirect_to admin_tour_path @tour
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = t "flash.find_tour_fail"
    redirect_to admin_tours_path
  end

  private
  def search_params
    params.permit :name_or_category_name_or_places_name_cont,
      :status_eq, :duration_eq, :tour_dates_start_date_eq, :num_people_gteq
  end

  def tour_params
    params.require(:tour).permit :name, :category_id, :num_people, :discount,
      :price_per_person, :description, :picture, :duration,
      tour_places_attributes: [:id, :place_id, :_destroy],
      tour_dates_attributes: [:id, :start_date, :_destroy]
  end
end
