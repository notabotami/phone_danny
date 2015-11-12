class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :setCityState

  def setCityState

  	@city = nil
    @state = nil

    if (not session[:state].nil?) and (not session[:city].nil?)
      @city = session[:city]
      @state = session[:state]
      @located_city = true
    end
    @located_city = false
  end

end
