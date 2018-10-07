class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @weather = ApixuApi.weather_in(params[:city])

    if @places.empty?
      redirect_to places_path, notice: "No places in #{params[:city]}"
    else
      session[:last_search] = params[:city]
      render :index
    end
  end

  def show
    if session[:last_search].empty? 
      redirect_to places_path
    else
      places = Rails.cache.fetch("PLACES_#{session[:last_search]}")
      @place = places.find { |place| place.id == params[:id] }
    end
  end
end
