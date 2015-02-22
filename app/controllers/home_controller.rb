class HomeController < ApplicationController
  
  force_non_ssl
  
  def index
  	
  	#@home_entities = HomeEntit
  end
  
  def weather
  	respond_to do |format|
  	  format.js { render }
      format.json { render json: 
      	{ 
      		id: current_region.id, 
      		name: current_region.name, 
      		temperature: current_region.current_temperature.to_int,
      		weather_icon: current_region.current_weather_icon,
      		summary: current_region.current_summary
      	}
      }
      
    end
  end
  
  
end
