class HomeController < ApplicationController
  def index
    @rooms = Room.all
    render json: @rooms
  end
end