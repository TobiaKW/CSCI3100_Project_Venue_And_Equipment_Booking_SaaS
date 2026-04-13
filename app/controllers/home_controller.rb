# Landing page for Venue & Equipment Booking app
class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @resources = Resource.all

    # Filter by rtype (room/equipment)
    @resources = @resources.where(rtype: (if params[:rtype] then params[:rtype] else 'room' end))

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
    
    # Filter and sort by similarity of name
    if params[:search].present?
      @resources = Resource.by_similarity @resources, params[:search]
    end
  end
end
