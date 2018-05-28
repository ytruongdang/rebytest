class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    @payment = Payment.new payment_params.merge(
      email: params["stripeEmail"],
      card_token: params["stripeToken"])
    @payment.process_payment
    @payment.save
    @payment.booking.update_attributes status: Booking.statuses[:paid]
    flash[:success] = t "flash.payment_success"
    redirect_to root_path
    rescue Stripe::CardError
      flash[:error] = t "flash.card_error"
      redirect_to new_charge_path
  end

  private
  def payment_params
    params.require(:payment).permit :booking_id
  end
end
