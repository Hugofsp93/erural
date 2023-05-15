module Api
  module V1
    class VideosController < ApplicationController
      before_action :authorize_access_request!, except: [:show, :index]
      before_action :set_video, only: %i[ show update destroy ]
    
      # GET /videos
      def index
        @videos = Video.all
    
        render json: @videos
      end
    
      # GET /videos/1
      def show
        render json: @video
      end
    
      # POST /videos
      def create
        @video = Video.new(video_params)
        
        if @video.save
          render json: @video, status: :created, location: api_v1_video_url(@video)
        else
          render json: @video.errors, status: :unprocessable_entity
        end
      end
    
      # PATCH/PUT /videos/1
      def update
        if @video.update(video_params)
          render json: @video
        else
          render json: @video.errors, status: :unprocessable_entity
        end
      end
    
      # DELETE /videos/1
      def destroy
        @video.destroy
      end
    
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_video
          @video = Video.find(params[:id])
        end
    
        # Only allow a list of trusted parameters through.
        def video_params
          params.require(:video).permit(:name, :url, :description, :room_id)
        end
    end
  end
end