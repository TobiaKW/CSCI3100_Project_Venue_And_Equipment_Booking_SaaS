# Landing page for Venue & Equipment Booking app
class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    # Root: show landing; add links to resources/bookings when those controllers exist
  end
end
