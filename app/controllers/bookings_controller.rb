class BookingsController < ApplicationController
  before_action :authenticate_user!

  load_resource :tour
  load_and_authorize_resource :booking, through: :tour, shallow: :true

  def create
    @booking.user = current_user
    @booking.status = Booking.statuses[:waiting_pay]
    if @booking.save
      @payment = Payment.new
      flash[:success] = t "flash.bookings.booking_success"
      render "payments/new"
    else
      @supports = Supports::TourSupport.new tour: @tour
      flash[:danger] = t "flash.bookings.create_booking_fail"
      render "tours/show"
    end
  end

  def index
    @bookings = current_user.bookings
      .order_desc.paginate page: params[:page],
      per_page: Settings.bookings.per_page_bookings
  end

  def show
    @payment = Payment.new
  end

  def update
    if @booking.update_attributes booking_params
      flash[:success] = t "flash.bookings.booking_canceled"
    else
      flash[:danger] = t "flash.bookings.booking_cancel_fail"
    end
    redirect_to bookings_path
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = t "flash.tours.tour_not_found"
    redirect_to root_path
  end

  private
  def booking_params
    params.require(:booking).permit :user_id, :tour_date_id,
      :num_tourist, :contact_name, :contact_phone, :contact_address,
      :description, :total_price, :status, :is_cancel
  end
end
