class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :setCityState

  def setCityState
  	logger.tagged("ApplicationController") {params}
  	city = params[:city]
  	state = params[:state]

  	
  	session[:accesspoint_city] = city
  	session[:accesspoint_state] = state
  end

end
