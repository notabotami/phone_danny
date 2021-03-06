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

  def page_plus_sim_card

  end

  def page_plus_port_in
      respond_to do |format|
        format.html # renders home.html.erb
        format.js {} # renders home.js.erb
      end
  end

  def page_plus_refill

  end

  def page_plus_activation_submit
  	first_name=params[:first_name]
  	last_name=params[:last_name]
  	email=params[:email]
    email_confirmation=params[:email_confirmation]
  	phone_type=params[:phone_type]
  	esn_number=params[:esn_number]
  	imei_number=params[:imei_number]
  	iccid_number=params[:iccid_number]
    billing_address=params[:billing_address]
    billing_city=params[:billing_city]
    billing_state=params[:billing_state]
  	zip_code=params[:zip_code]
  	payment_plan=params[:payment_plan]
    @phone_service=params[:phone_service]


    #assume no errors to begin with
    error_message_hash = {:name_missing => nil, 
      :email_missing => nil,
      :phone_type_missing => nil,
      :esn_number_missing => nil,
      :imei_number_missing => nil,
      :iccid_number_missing => nil,
      :billing_address_missing => nil,
      :billing_city_missing => nil,
      :billing_state_missing => nil,
      :zip_code_missing => nil,
      :payment_plan_missing => nil}

    #price in cents
    if(@phone_service == "PagePlus")
      billing_state = "N/A"
      billing_city = "N/A"
      billing_address = "N/A"

      payment_plan_hash = {"1" => 1200,
        "2" => 2995,
        "3" => 3995,
        "4" => 5500,
        "5" => 6995}
    else
      payment_plan_hash = {"a" => 1500,
        "b" => 2000,
        "c" => 3000,
        "d" => 4000,
        "e" => 5500,
        "f" => 7000,
        "g" => 7500,
        "h" => 10000}

    end

    amount = payment_plan_hash[payment_plan]

    phone_type_hash = {"1" => "3g",
      "2" => "4g"}

    @params={}

    #
    #validate data coming in and fill out error_message_hash if necessary
    if(first_name.blank? or last_name.blank?)
      error_message_hash[:name_missing] = "Please fill out your first and last name."
    else
      @params[:first_name] = first_name
      @params[:last_name] = last_name
    end

    if(email.blank? or email_confirmation.blank? or (email != email_confirmation))
      error_message_hash[:email_missing] = "Please fill out and confirm your email.  Make sure you write the correct email."
    else
      @params[:email] = email
      @params[:email_confirmation] = email_confirmation
    end

    if(phone_type.blank? or not (phone_type == "1" or phone_type == "2"))
      error_message_hash[:phone_type_missing] = "Please choose either 3g or 4g."
    else
      @params[:phone_type] = phone_type
    end

    if(esn_number.blank? and (phone_type == "1"))
      error_message_hash[:esn_number_missing] = "Please fill out the ESN information."
    else
      @params[:esn_number] = esn_number
    end

    if(imei_number.blank? and (phone_type == "2"))
      error_message_hash[:imei_number_missing] = "Please fill out your IMEI number"
    else
      @params[:imei_number] = imei_number
    end

    if(iccid_number.blank? and (phone_type == "2"))
      error_message_hash[:iccid_number_missing] = "Please fill out your ICCID number."
    else
      @params[:iccid_number] = iccid_number
    end


    if(billing_address.blank? and @phone_service == "Selectel")
      error_message_hash[:account_address_missing] = "Please fill out your account's billing address.  Call your carrier to verify."
    else
      @params[:billing_address] = billing_address
    end

    if(billing_city.blank? and @phone_service == "Selectel")
      error_message_hash[:account_city_missing] = "Please fill out your account's billing city.  Call your carrier to verify."
    else
      @params[:billing_city] = billing_city
    end

    if(billing_state.blank? and @phone_service == "Selectel")
      error_message_hash[:account_state_missing] = "Please fill out your account's billing state.  Call your carrier to verify."
    else
      @params[:billing_state] = billing_state
    end


    if(zip_code.blank?)
      error_message_hash[:zip_code_missing] = "Please fill out your zip code."
    else
      @params[:zip_code] = zip_code
    end

    if(payment_plan.blank?)
      error_message_hash[:payment_plan_missing] = "Please choose a payment plan."
    else
      @params[:payment_plan] = payment_plan
    end

    @error_found = false
    @error_string = ""

    error_message_hash.each do |key, value|
      if(not value.blank?)
        @error_found = true
        @error_string = @error_string + value + "<br>"
      end
    end

    logger.tagged("activation submit"){logger.debug(error_message_hash)}
    if(@error_found)
      flash[:danger] = @error_string.html_safe
      render 'page_plus_activation/page_plus_activation'

    else
    
      if(phone_type == "1")
        imei_number = "N/A"
        iccid_number = "N/A"
      else
        esn_number = "N/A"
      end

      phone_type = phone_type_hash[phone_type]

      if(@phone_service == "PagePlus")

        payment_plan_hash = {"1" => t("page_plus_activation.page_plus_plan_one"),
          "2" => t("page_plus_activation.page_plus_plan_two"),
          "3" => t("page_plus_activation.page_plus_plan_three"),
          "4" => t("page_plus_activation.page_plus_plan_four"),
          "5" => t("page_plus_activation.page_plus_plan_five")}
      else
        payment_plan_hash = {"a" => t("page_plus_activation.selectel_wireless_plan_one"),
          "b" => t("page_plus_activation.selectel_wireless_plan_two"),
          "c" => t("page_plus_activation.selectel_wireless_plan_three"),
          "d" => t("page_plus_activation.selectel_wireless_plan_four"),
          "e" => t("page_plus_activation.selectel_wireless_plan_five"),
          "f" => t("page_plus_activation.selectel_wireless_plan_six"),
          "g" => t("page_plus_activation.selectel_wireless_plan_seven"),
          "h" => t("page_plus_activation.selectel_wireless_plan_eight")}

      end



      payment_plan = payment_plan_hash[payment_plan]

      description="(#{@phone_service} ACTIVATION) | Name: " + first_name + " "+ last_name + ", " + 
      "Email: " + email + ", " + 
      "Phone Type: " + phone_type + ", " + 
      "ESN Number: " + esn_number + ", " + 
      "IMEI_number: " + imei_number + ", "+ 
      "ICCID Number: " + iccid_number + ", " + 
      "Billing Address: " + billing_address + ", " + 
      "Billing City: " + billing_city + ", " + 
      "Billing State: " + billing_state + ", " + 
      "Zipcode: " + zip_code + ", " + 
      "Payment Plan: " + payment_plan

      logger.tagged("activation submit"){logger.debug(description)}


      charge = Stripe::Charge.create(
        :amount => amount + 200, # amount in cents, again
        :currency => "usd",
        :source => params[:stripeToken],
        :description => description
      )


      #PaymentNotifier.purchase_email(description).deliver!


      flash[:success] = "Your information has been submitted.  Your credit card won't be charged until we can submit your information."
    	
      if(@phone_service == "PagePlus")
        redirect_to("/page_plus_activation")
      else
        redirect_to("/selectel_activation")
      end

    end


  rescue Stripe::CardError => e
    flash[:error] = e.message
    if(@phone_service == "PagePlus")
      redirect_to("/page_plus_activation")
    else
      redirect_to("/selectel_activation")
    end
  end

  def page_plus_sim_card_submit
    first_name=params[:first_name]
    last_name=params[:last_name]
    email=params[:email]
    email_confirmation=params[:email_confirmation]
    sim_card_size= if params[:sim_card_size].nil? then "N/A" else params[:sim_card_size] end
    shipping_address=params[:shipping_address]
    shipping_city=params[:shipping_city]
    shipping_state=params[:shipping_state]
    zip_code=params[:zip_code]
    @phone_service=params[:phone_service]


    #assume no errors to begin with
    error_message_hash = {:name_missing => nil, 
      :email_missing => nil,
      :sim_card_size_missing => nil,
      :shipping_address_missing => nil,
      :shipping_city_missing => nil,
      :shipping_state_missing => nil,
      :zip_code_missing => nil}


    @params={}

    #
    #validate data coming in and fill out error_message_hash if necessary
    if(first_name.blank? or last_name.blank?)
      error_message_hash[:name_missing] = "Please fill out your first and last name."
    else
      @params[:first_name] = first_name
      @params[:last_name] = last_name
    end

    if(email.blank? or email_confirmation.blank? or (email != email_confirmation))
      error_message_hash[:email_missing] = "Please fill out and confirm your email.  Make sure you write the correct email."
    else
      @params[:email] = email
      @params[:email_confirmation] = email_confirmation
    end

    if(shipping_address.blank?)
      error_message_hash[:shipping_address_missing] = "Please fill out your account's shipping address.  Call your carrier to verify."
    else
      @params[:shipping_address] = shipping_address
    end

    if(shipping_city.blank?)
      error_message_hash[:shipping_city_missing] = "Please fill out your account's shipping city.  Call your carrier to verify."
    else
      @params[:shipping_city] = shipping_city
    end

    if(shipping_state.blank?)
      error_message_hash[:shipping_state_missing] = "Please fill out your account's shipping state.  Call your carrier to verify."
    else
      @params[:shipping_state] = shipping_state
    end


    if(zip_code.blank?)
      error_message_hash[:zip_code_missing] = "Please fill out your zip code."
    else
      @params[:zip_code] = zip_code
    end


    @error_found = false
    @error_string = ""

    error_message_hash.each do |key, value|
      if(not value.blank?)
        @error_found = true
        @error_string = @error_string + value + "<br>"
      end
    end

    logger.tagged("activation submit"){logger.debug(error_message_hash)}
    if(@error_found)
      flash[:danger] = @error_string.html_safe
      render 'page_plus_activation/page_plus_sim_card'

    else

      description="(#{@phone_service} SIM CARD ORDER) | Name: " + first_name + " "+ last_name + ", " + 
      "Email: " + email + ", " + 
      "SIM Card Size: " + sim_card_size+ ", " + 
      "Shipping Address: " + shipping_address + ", " + 
      "Shipping City: " + shipping_city + ", " + 
      "Shipping State: " + shipping_state + ", " + 
      "Zipcode: " + zip_code


      charge = Stripe::Charge.create(
        :amount => 800 + 200, # amount in cents, again
        :currency => "usd",
        :source => params[:stripeToken],
        :description => description
      )


      

      flash[:success] = "Your information has been submitted.  Your credit card won't be charged until we can submit your information.  We'll notify you as soon as we ship your SIM card out."
      
      if(@phone_service == "PagePlus")
        redirect_to("/page_plus_sim_card")
      else
        redirect_to("/selectel_sim_card")
      end

    end


  rescue Stripe::CardError => e
    flash[:error] = e.message
    if(@phone_service == "PagePlus")
      redirect_to("/page_plus_sim_card")
    else
      redirect_to("/selectel_sim_card")
    end
  end

  def page_plus_refill_submit

    email=params[:email]
    email_confirmation=params[:email_confirmation]
    phone_number=params[:phone_number]
    payment_plan=params[:payment_plan]
    @phone_service=params[:phone_service]

    #assume no errors to begin with
    error_message_hash = {:email_missing => nil,
      :phone_number_missing => nil,
      :payment_plan_missing => nil}

    #price in cents
    if(@phone_service == "PagePlus")
      payment_plan_hash = {"1" => 1200,
        "2" => 2995,
        "3" => 3995,
        "4" => 5500,
        "5" => 6995}
    else
      payment_plan_hash = {"a" => 1500,
        "b" => 2000,
        "c" => 3000,
        "d" => 4000,
        "e" => 5500,
        "f" => 7000,
        "g" => 7500,
        "h" => 10000}

    end

    amount = payment_plan_hash[payment_plan]

    @params = {}

    #
    #validate data coming in and fill out error_message_hash if necessary


    if(email.blank? or email_confirmation.blank? or (email != email_confirmation))
      error_message_hash[:email_missing] = "Please fill out and confirm your email.  Make sure you write the correct email."
    else
      @params[:email] = email
      @params[:email_confirmation] = email_confirmation
    end

    

    if(phone_number.blank? or not (ApplicationHelper.phone_number?(phone_number)))
      error_message_hash[:phone_type_missing] = "Please gives us the phone number to refill."
    else
      @params[:phone_number] = phone_number
    end

    if(payment_plan.blank?)
      error_message_hash[:payment_plan_missing] = "Please choose a payment plan."
    else
      @params[:payment_plan] = payment_plan
    end

    @error_found = false
    @error_string = ""

    error_message_hash.each do |key, value|
      if(not value.blank?)
        @error_found = true
        @error_string = @error_string + value + "<br>"
      end
    end

    logger.tagged("refill submit"){logger.debug(@phone_service == "PagePlus")}
    if(@error_found)
      flash[:danger] = @error_string.html_safe
      render 'page_plus_activation/page_plus_refill'

    else
    

      
      if(@phone_service == "PagePlus")

        payment_plan_hash = {"1" => t("page_plus_activation.page_plus_plan_one"),
          "2" => t("page_plus_activation.page_plus_plan_two"),
          "3" => t("page_plus_activation.page_plus_plan_three"),
          "4" => t("page_plus_activation.page_plus_plan_four"),
          "5" => t("page_plus_activation.page_plus_plan_five")}
      else
        payment_plan_hash = {"a" => t("page_plus_activation.selectel_wireless_plan_one"),
          "b" => t("page_plus_activation.selectel_wireless_plan_two"),
          "c" => t("page_plus_activation.selectel_wireless_plan_three"),
          "d" => t("page_plus_activation.selectel_wireless_plan_four"),
          "e" => t("page_plus_activation.selectel_wireless_plan_five"),
          "f" => t("page_plus_activation.selectel_wireless_plan_six"),
          "g" => t("page_plus_activation.selectel_wireless_plan_seven"),
          "h" => t("page_plus_activation.selectel_wireless_plan_eight")}

      end

      payment_plan = payment_plan_hash[payment_plan]

      description="(#{@phone_service} REFILL/REPLENISH) | Email: " + email + ", " + "Phone Number: " + phone_number + ", "  + "Payment Plan: " + payment_plan

      logger.tagged("refill submit"){logger.debug(description)}

      charge = Stripe::Charge.create(
        :amount => amount + 200, # amount in cents, again
        :currency => "usd",
        :source => params[:stripeToken],
        :description => description
      )


      

      flash[:success] = "Your information has been submitted.  Your credit card won't be charged until we can submit your information."
      if(@phone_service == "PagePlus")
        redirect_to("/page_plus_refill")
      else
        redirect_to("/selectel_refill")
      end

    end


  rescue Stripe::CardError => e
    flash[:error] = e.message
    if(@phone_service == "PagePlus")
      redirect_to("/page_plus_refill")
    else
      redirect_to("/selectel_refill")
    end
  end

  def page_plus_port_in_submit
    first_name=params[:first_name]
    last_name=params[:last_name]
    email=params[:email]
    email_confirmation=params[:email_confirmation]
    contact_number=params[:contact_number]
    phone_number=params[:phone_number]
    phone_type=params[:phone_type]
    esn_number=params[:esn_number]
    imei_number=params[:imei_number]
    iccid_number=params[:iccid_number]
    current_carrier=params[:current_carrier]
    account_number=params[:account_number]
    account_passcode=params[:account_passcode]
    billing_address=params[:billing_address]
    billing_city=params[:billing_city]
    billing_state=params[:billing_state]
    zip_code=params[:zip_code]
    payment_plan=params[:payment_plan]
    @phone_service=params[:phone_service]


    #assume no errors to begin with
    error_message_hash = {:name_missing => nil, 
      :email_missing => nil,
      :contact_number_missing => nil,
      :phone_number_missing => nil,
      :phone_type_missing => nil,
      :esn_number_missing => nil,
      :imei_number_missing => nil,
      :iccid_number_missing => nil,
      :current_carrier_missing => nil,
      :account_number_missing => nil,
      :account_passcode_missing => nil,
      :billing_address_missing => nil,
      :billing_city_missing => nil,
      :billing_state_missing => nil,
      :zip_code_missing => nil,
      :payment_plan_missing => nil}

        #price in cents
    if(@phone_service == "PagePlus")
      payment_plan_hash = {"1" => 1200,
        "2" => 2995,
        "3" => 3995,
        "4" => 5500,
        "5" => 6995}
    else
      payment_plan_hash = {"a" => 1500,
        "b" => 2000,
        "c" => 3000,
        "d" => 4000,
        "e" => 5500,
        "f" => 7000,
        "g" => 7500,
        "h" => 10000}

    end

    amount = payment_plan_hash[payment_plan]

    phone_type_hash = {"1" => "3g",
      "2" => "4g"}

    @params = {}

    #
    #validate data coming in and fill out error_message_hash if necessary
    if(first_name.blank? or last_name.blank?)
      error_message_hash[:name_missing] = "Please fill out your first and last name."
    else
      @params[:first_name] = first_name
      @params[:last_name] = last_name
    end

    if(email.blank? or email_confirmation.blank? or (email != email_confirmation))
      error_message_hash[:email_missing] = "Please fill out and confirm your email.  Make sure you write the correct email."
    else
      @params[:email] = email
      @params[:email_confirmation] = email_confirmation
    end

    #TODO: is a contact number necessary?
    if(contact_number.blank? or not (ApplicationHelper.phone_number?(contact_number)))

    else
      @params[:contact_number] = contact_number
    end

    if(phone_number.blank? or not (ApplicationHelper.phone_number?(phone_number)))
      error_message_hash[:phone_type_missing] = "Please gives us a valid phone number to port in."
    else
      @params[:phone_number] = phone_number
    end

    if(phone_type.blank? or not (phone_type == "1" or phone_type == "2"))
      error_message_hash[:phone_type_missing] = "Please choose either 3g or 4g."
    else
      @params[:phone_type] = phone_type
    end

    if(esn_number.blank? and (phone_type == "1"))
      error_message_hash[:esn_number_missing] = "Please fill out the ESN information."
    else
      @params[:esn_number] = esn_number
    end

    if(imei_number.blank? and (phone_type == "2"))
      error_message_hash[:imei_number_missing] = "Please fill out your IMEI number"
    else
      @params[:imei_number] = imei_number
    end

    if(iccid_number.blank? and (phone_type == "2"))
      error_message_hash[:iccid_number_missing] = "Please fill out your ICCID number."
    else
      @params[:iccid_number] = iccid_number
    end
     
     
    if(current_carrier.blank?)
      error_message_hash[:current_carrier_missing] = "Please fill out your current carrier e.g. 'Sprint', 'Verizon', etc."
    else
      @params[:current_carrier] = current_carrier
    end

    if(account_number.blank?)
      error_message_hash[:account_number_missing] = "Please fill out your account number.  Call your carrier to verify."
    else
      @params[:account_number] = account_number
    end

    if(account_passcode.blank?)
      error_message_hash[:account_passcode_missing] = "Please fill out your account passcode.  Call your carrier to verify."
    else
      @params[:account_passcode] = account_passcode
    end

    if(billing_address.blank?)
      error_message_hash[:account_address_missing] = "Please fill out your account's billing address.  Call your carrier to verify."
    else
      @params[:billing_address] = billing_address
    end

    if(billing_city.blank?)
      error_message_hash[:account_city_missing] = "Please fill out your account's billing city.  Call your carrier to verify."
    else
      @params[:billing_city] = billing_city
    end

    if(billing_state.blank?)
      error_message_hash[:account_state_missing] = "Please fill out your account's billing state.  Call your carrier to verify."
    else
      @params[:billing_state] = billing_state
    end


    if(zip_code.blank?)
      error_message_hash[:zip_code_missing] = "Please fill out your zip code."
    else
      @params[:zip_code] = zip_code
    end

    if(payment_plan.blank?)
      error_message_hash[:payment_plan_missing] = "Please choose a payment plan."
    else
      @params[:payment_plan] = payment_plan
    end

    @error_found = false
    @error_string = ""

    error_message_hash.each do |key, value|
      if(not value.blank?)
        @error_found = true
        @error_string = @error_string + value + "<br>"
      end
    end

    logger.tagged("port in submit"){logger.debug(@params)}
    if(@error_found)
      flash[:danger] = @error_string.html_safe
      render 'page_plus_activation/page_plus_port_in'

    else
    
      if(phone_type == "1")
        imei_number = "N/A"
        iccid_number = "N/A"
      else
        esn_number = "N/A"
      end

      phone_type = phone_type_hash[phone_type]
      
      if(@phone_service == "PagePlus")

        payment_plan_hash = {"1" => t("page_plus_activation.page_plus_plan_one"),
          "2" => t("page_plus_activation.page_plus_plan_two"),
          "3" => t("page_plus_activation.page_plus_plan_three"),
          "4" => t("page_plus_activation.page_plus_plan_four"),
          "5" => t("page_plus_activation.page_plus_plan_five")}
      else
        payment_plan_hash = {"a" => t("page_plus_activation.selectel_wireless_plan_one"),
          "b" => t("page_plus_activation.selectel_wireless_plan_two"),
          "c" => t("page_plus_activation.selectel_wireless_plan_three"),
          "d" => t("page_plus_activation.selectel_wireless_plan_four"),
          "e" => t("page_plus_activation.selectel_wireless_plan_five"),
          "f" => t("page_plus_activation.selectel_wireless_plan_six"),
          "g" => t("page_plus_activation.selectel_wireless_plan_seven"),
          "h" => t("page_plus_activation.selectel_wireless_plan_eight")}

      end

      payment_plan = payment_plan_hash[payment_plan]


      description="(#{@phone_service} PORT IN) | Name: " + first_name + " "+ last_name + ", " + 
      "Email: " + email + ", " + 
      "Contact Number: " + contact_number + ", " +
      "Phone Number to Port: " + phone_number + ", " +
      "Phone Type: " + phone_type + ", " + 
      "ESN Number: " + esn_number + ", " + 
      "IMEI_number: " + imei_number + ", "+ 
      "ICCID Number: " + iccid_number + ", " + 
      "Current Carrier: " + current_carrier + ", " + 
      "Account Number: " + account_number + ", " + 
      "Account Passcode: " + account_passcode + ", " + 
      "Billing Address: " + billing_address + ", " + 
      "Billing City: " + billing_city + ", " + 
      "Billing State: " + billing_state + ", " + 
      "Zipcode: " + zip_code + ", " + 
      "Payment Plan: " + payment_plan

      logger.tagged("port in submit"){logger.debug(description)}


      charge = Stripe::Charge.create(
        :amount => amount + 200, # amount in cents, again
        :currency => "usd",
        :source => params[:stripeToken],
        :description => description
      )


      

      flash[:success] = "Your information has been submitted.  Your credit card won't be charged until we can submit your information."
      
      if(@phone_service == "PagePlus")
        redirect_to("/page_plus_port_in")
      else
        redirect_to("/selectel_port_in")
      end

    end


  rescue Stripe::CardError => e
    flash[:error] = e.message
    if(@phone_service == "PagePlus")
      redirect_to("/page_plus_port_in")
    else
      redirect_to("/selectel_port_in")
    end
  end

  def page_plus_number_status

    respond_to do |format|
      format.html # renders home.html.erb
      format.js {} # renders home.js.erb
      format.json {}
    end

  end


  def page_plus_number_status_submit
    #TODO: validate/normalize phone number (555) 555-5555 == 555-555-5555 == 5555555555

    possible_phone_number = params["phone_number"]

    phone_number = ApplicationHelper.phone_number?(possible_phone_number)
    @correct_number_format = phone_number != nil

    if( not @correct_number_format) then
      flash[:warning] = "Please enter a 10-digit US number"
      render 'page_plus_activation/page_plus_number_status'
    else

      logger.tagged("number status submit"){logger.debug(phone_number)}


      agent = Mechanize.new
      
      

      page = agent.get "https://www.pagepluscellular.com/login/"
      plus_form = page.form(:action => '/login/')
      plus_form.username = ENV["ACCESSPOINT_USERNAME"]
      plus_form.password = ENV["ACCESSPOINT_PASSWORD"]

      page = agent.submit(plus_form,plus_form.buttons.first)

      page = agent.page.link_with(:text => 'MDN/Number Status').click

      #<form method="post" action="/dealer-tools/mdnnumber-status.aspx" id="form1" class="mainform">
      plus_form = page.form(:action => "/dealer-tools/mdnnumber-status.aspx")

      #<input name="ctl00$ctl00$ctl00$ContentPlaceHolderDefault$mainContentArea$Item3$AccountStatus_5$txtPhone" type="text" id="ContentPlaceHolderDefault_mainContentArea_Item3_AccountStatus_5_txtPhone" tabindex="1" class="phone">
      plus_form["ctl00$ctl00$ctl00$ContentPlaceHolderDefault$mainContentArea$Item3$AccountStatus_5$txtPhone"] = phone_number


      #<span id="ContentPlaceHolderDefault_mainContentArea_Item3_AccountStatus_5_lbl_message" style="color:Red;"></span>
      #<span id="ContentPlaceHolderDefault_mainContentArea_Item3_AccountStatus_5_lbl_message" style="color:Red;">Phone number is invalid or is not a Page Plus customer</span>
      
      page = agent.submit(plus_form,plus_form.button_with(:value => 'Next'))

      logger.tagged("number status submit"){logger.debug(page.search('.rightcol .maintext').inner_text == "")}

      @valid_number = true

      if( not @valid_number) then
        flash[:warning] = "You did not enter a valid PagePlus number"

        respond_to do |format|
          format.html {render 'page_plus_activation/page_plus_number_status'}
          format.json {render json: {:errors => "I'm an error!"}, status: 422}
        end

      else

        #logger.tagged("number status submit"){logger.debug(page.search('.rightcol .maintext').inner_text)}
        phone_status_hash = {:phone_number => nil, 
          :min => nil, 
          :status => nil,
          :rate_plan => nil,
          :balance => nil,
          :expiration_date => nil,
          :feature => nil,
          :plan_balance_details => nil}

        i = 1

        plan_b = ""

        page.search('.rightcol .maintext').each do |t|
          #logger.tagged("phone_status_hash" + i.to_s){logger.debug(t.inner_text.strip)}
          if(i == 2) then
            phone_status_hash[:phone_number] = t.inner_text.strip
          elsif(i == 4) then
            phone_status_hash[:min] = t.inner_text.strip
          elsif(i == 6) then
            phone_status_hash[:status] = t.inner_text.strip
          elsif(i == 8) then
            phone_status_hash[:rate_plan] = t.inner_text.strip
          elsif(i == 10) then
            phone_status_hash[:balance] = t.inner_text.strip
          elsif(i == 12) then
            phone_status_hash[:expiration_date] = t.inner_text.strip
          elsif(i == 14) then
            phone_status_hash[:feature] = t.inner_html.html_safe
          elsif(i == 16) then
            
            plan_b = t

            #logger.tagged("plan_b"){logger.debug(pp plan_b)}
            k = 1
            plan_balance_details = ""
            plan_b.search("div div").each do |x|
              #logger.tagged("plan_b" + k.to_s){logger.debug(x.inner_html)}
              if(k==2) then
                plan_balance_details = plan_balance_details + x.inner_html + "<br>"
              elsif(k==8) then
                plan_balance_details = plan_balance_details + "minutes: " + x.inner_html + "<br>"
              elsif(k==9) then
                plan_balance_details = plan_balance_details + "texts: " + x.inner_html + "<br>"
              elsif(k==10) then
                plan_balance_details = plan_balance_details + "data: " + x.inner_html + "<br>"
              end
                

              k=k+1
            end
            phone_status_hash[:plan_balance_details] = plan_balance_details
          elsif(i==20) then
            logger.tagged("plan details 20"){logger.debug(pp t.search("div div"))}
            t.search("b").each do |x|
              phone_status_hash[:plan_balance_details] = phone_status_hash[:plan_balance_details] + "<br>" + x.inner_text
            end
            phone_status_hash[:plan_balance_details] = phone_status_hash[:plan_balance_details].html_safe
          end

          i = i + 1
        end  
        
        logger.tagged("phone_status_hash"){logger.debug(phone_status_hash)}



        @phone_status_hash = phone_status_hash
        @html_body=phone_status_hash.to_s



      end
    end
  end



end
