class PagePlusActivationController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def page_plus_activation



    respond_to do |format|
      format.html # renders home.html.erb
      format.js {} # renders home.js.erb
    end

  end

def page_plus_port_in
    respond_to do |format|
      format.html # renders home.html.erb
      format.js {} # renders home.js.erb
    end
end

def page_plus_activation_submit
	first_name=params[:first_name]
	last_name=params[:last_name]
	email=params[:email]
	phone_type=params[:phone_type]
	esn_number=params[:esn_number]
	imei_number=params[:imei_number]
	iccid_number=params[:iccid_number]
	zip_code=params[:zip_code]
	payment_plan=params[:payment_plan]

	redirect_to("/page_plus_activation")


end



end
