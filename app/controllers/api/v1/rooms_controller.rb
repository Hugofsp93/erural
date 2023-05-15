module Api
  module V1
    class RoomsController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_room, only: %i[ show update destroy ]
    
      # GET /rooms
      def index
        @rooms = current_user.rooms.all
    
        render json: @rooms
      end
    
      # GET /rooms/1
      def show
        render json: @room
      end
    
      # POST /rooms
      def create
        @room = current_user.rooms.build(room_params)
        
        if @room.save
          render json: @room, status: :created, location: api_v1_room_url(@room)
        else
          render json: @room.errors, status: :unprocessable_entity
        end
      end
    
      # PATCH/PUT /rooms/1
      def update
        if @room.update(room_params)
          render json: @room
        else
          render json: @room.errors, status: :unprocessable_entity
        end
      end
    
      # DELETE /rooms/1
      def destroy
        @room.destroy
      end
    
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_room
          @room = current_user.rooms.find(params[:id])
        end
    
        # Only allow a list of trusted parameters through.
        def room_params
          params.require(:room).permit(:name, :description, :access_code, :open)
        end
    end
  end
end