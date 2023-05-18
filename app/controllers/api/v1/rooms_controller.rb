module Api
  module V1
    class RoomsController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_room, only: %i[ show update destroy ]
    
      # GET /rooms
      def index
        @rooms = current_user.rooms.all
        render json: @rooms.as_json
      end
    
      # GET /rooms/1
      def show
        render json: @room.as_json
      end
    
      # POST /rooms
      def create
        @room = current_user.rooms.build(room_params)
        
        if @room.save
          render json: @room.as_json, status: :created, location: api_v1_room_url(@room)
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

      def add_video
        @room = Room.find(params[:id])
        video = Video.new(name: params[:name], url: params[:url], description: params[:description], room: @room)
        
        if video.save
          render json: { video: video.as_json }, status: :created
        else
          render json: { errors: video.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def play_video
        @room = Room.find(params[:id])
        @room.update(open: false) # Atualiza o status da sala para indicar que um vídeo está sendo reproduzido

        render json: { room: @room }
      end

      def videos
        room = Room.find(params[:id])
        videos = room.videos
        
        render json: videos
      end

      def access
        room = Room.find(params[:room_id])
        
        if room.access_key == params[:access_code]
          render json: { success: true, message: 'Bem-vindo a sala' }
        else
          render json: { success: false, message: 'Código de acesso não é válido' }
        end
      rescue ActiveRecord::RecordNotFound
        render json: { success: false, message: 'Sala não encontrada' }
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