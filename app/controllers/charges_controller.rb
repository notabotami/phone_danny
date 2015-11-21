class ChargesController < ApplicationController

	def new
		
	end

	def create
	  # Amount in cents
	  @amount=params[:amount]
	  if @amount == "500" then
	  	@amount = 500
	  elsif @amount == "1000" then
	  	@amount = 1000
	  elsif @amount == "1500" then
	  	@amount = 1500
	  else
	  	@amount = nil
	  	redirect_to "/charges/new"
	  end

	  

	  customer = Stripe::Customer.create(
	    :email => params[:stripeEmail],
	    :source  => params[:stripeToken],
	    :description => "Customer being created!"
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => @amount,
	    :description => 'Rails Stripe customer\naline\nanother line<br>testline',
	    :currency    => 'usd'
	  )

	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to new_charge_path
	end

end
