class HomeController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception



  def home

    #logger.tagged("HomeController") {logger.info(HTTP.get("https://www.pagepluscellular.com/login/").to_s)}



  	state = params[:state]
  	city = params[:city]

  	@located_city = true

  	if state.nil? or city.nil?
  		@located_city = false

  	else
      session[:city] = city
      session[:state] = state
      @city = city
      @state = state
      
  		@city_formal = TestHelper.formalize(city)
  		@state_formal = TestHelper.formalize(state)
  	end





    respond_to do |format|
      format.html # renders home.html.erb
      format.js {} # renders home.js.erb
    end

  end


end