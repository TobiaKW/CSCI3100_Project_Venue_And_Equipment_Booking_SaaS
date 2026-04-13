# Landing page for Venue & Equipment Booking app
class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @resources = Resource.all

    pp(params)
    # Filter by name
    if params[:search].present?
      @resources = @resources.where("name ILIKE ?", "%#{params[:search]}%")
    end

    # Filter by rtype (room/equipment)
    if params[:rtype].present?
      @resources = @resources.where(rtype: params[:rtype])
    end

    # Filter by department
    if params[:department_id].present?
      @resources = @resources.where(department_id: params[:department_id])
    end

    # Filter by capacity
    if params[:min_capacity].present?
      @resources = @resources.where("capacity >= ? or rtype = 'equipment'", params[:min_capacity])
    end
    if params[:max_capacity].present?
      @resources = @resources.where("capacity <= ? or rtype = 'equipment'", params[:max_capacity])
    end

    # Filter by seat type
    if params[:seat_type].present? and params[:seat_type] != 'All Seat Types'
      @resources = @resources.where("seat_type = ? or rtype = 'equipment'", params[:seat_type])
    end
    
    # @resources = @resources.order(capacity: :desc)
  end
end
