class Supports::BookingSupport
  def initialize params
    @q = params[:booking]
    @page = params[:page]
  end

  def load_bookings
    @bookings = @q.result.order_desc.paginate page: @page,
      per_page: Settings.bookings.per_page_bookings
  end

  def load_status
    @statuses ||= Booking.statuses
  end
end
