# Landing page for Venue & Equipment Booking app
class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @resources = Resource.all

    # Filter by name
    if params[:search].present?
      @resources = @resources.where("name ILIKE ?", "%#{params[:search]}%")
    end

    # Filter by rtype (room/equipment)
    if params[:rtypes].present?
      @resources = @resources.where(rtype: params[:rtypes])
    end
    
  end
end
