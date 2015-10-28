class LocateController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def fetch
  	state = params["state"]
  	@page_number = params["page_number"].to_i
  	logger.tagged("TestController") {logger.debug state}
  	path_without_root = "app/assets/cities/condensed_cities_" + state + ".txt"
  	@path = Rails.root + path_without_root

    respond_to do |format|
      format.html # renders home.html.erb
      format.js {} # renders home.js.erb
    end

  end

  def locate_state

  end

  def locate_city
    state = params["state"]
    @page_number = params["page_number"].to_i
    path_without_root = "app/assets/cities/condensed_cities_" + state + ".txt"
    @path = Rails.root + path_without_root

  end



end
