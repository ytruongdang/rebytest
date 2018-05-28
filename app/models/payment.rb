class Payment < ApplicationRecord
  acts_as_paranoid

  belongs_to :booking
  belongs_to :bank_card

  def process_payment
    customer = Stripe::Customer.create email: email,
      card: card_token
    charge = Stripe::Charge.create customer: customer.id,
      amount: booking.total_price.to_i * 100,
      description: booking.description,
      currency: "usd"
    self.charge_token = charge.id
    self.customer_token = customer.id
  end

  def process_refund
    Stripe::Refund.create charge: self.charge_token
  end
end
