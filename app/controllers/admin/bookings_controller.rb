class Admin::BookingsController < Admin::ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def index
    @q = Booking.ransack params
    @supports = Supports::BookingSupport.new booking: @q,
      page: params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    load_status
  end

  def update
    status_before = @booking.status
    if @booking.waiting_pay? && booking_params[:status] == "approve"
      flash[:danger] = t "flash.bookings.booking_cannot_approve"
      redirect_to admin_bookings_path
    else
      if @booking.update_attributes booking_params
        if @booking.reject? && status_before == "waiting_pay"
          flash[:success] = t "flash.bookings.booking_canceled"
        elsif @booking.reject? && status_before == "paid"
          @booking.payment.process_refund
          flash[:success] = t "flash.bookings.booking_rejected"
        else
          flash[:success] = t "flash.bookings.booking_approved"
        end
        redirect_to admin_bookings_path
      else
        load_status
        flash[:danger] = t "flash.bookings.booking_update_fail"
        render :show
      end
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = t "flash.bookings.booking_not_found"
    redirect_to admin_bookings_path
  end

  private
  def booking_params
    params.require(:booking).permit :status
  end

  def load_status
    @statuses ||= Booking.statuses
      .except(:waiting_pay, :paid).map {|key, value| [key.humanize, key]}
  end
end
