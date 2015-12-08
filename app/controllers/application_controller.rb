class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :setCityState
  before_filter :setPhoneService
  before_filter :set_language

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

  def setPhoneService

    current_uri = request.env['PATH_INFO']
    logger.tagged("ApplicationController"){logger.debug(current_uri)}
    @phone_service = "PagePlus"
    if current_uri.include? "selectel"
      @phone_service = "Selectel"
    end

  end

  def set_language

    if(session[:language].nil? or session[:language] == "en")
      session[:language] = "en"
      I18n.locale = :en
    else
      session[:language] = "es"
      I18n.locale = :es
    end


  end

  def change_language
    if I18n.locale.nil? or I18n.locale == :en
      session[:language] = "es"
      I18n.locale = :es
    else
      session[:language] = "en"
      I18n.locale = :en
    end

    redirect_to home_path
  end

end
