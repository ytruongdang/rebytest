class ToursController < ApplicationController
  load_resource

  def index
    @order_rules = [:asc, :desc].map {|rule| [I18n.t("order_rules.#{rule}"), rule]}

    @tours = Tour.available.distinct
      .price_between(params[:from_price], params[:to_price])
      .rating_order(params[:rating_rule]).price_order(params[:price_rule])
      .search(search_params).result.paginate page: params[:page],
      per_page: Settings.tours.tours_per_page
  end

  def show
    @supports = Supports::TourSupport.new tour: @tour, page: params[:page]
    @booking = Booking.new
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = t "flash.find_tour_fail"
    redirect_to root_path
  end

  private
  def search_params
    params.permit :name_or_category_name_or_places_name_cont, :duration_eq,
      :tour_dates_start_date_eq, :num_people_gteq
  end
end
