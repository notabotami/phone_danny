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

  def page_plus_number_status

    respond_to do |format|
      format.html # renders home.html.erb
      format.js {} # renders home.js.erb
    end

  end

  def page_plus_number_status_submit
    #TODO: validate/normalize phone number (555) 555-5555 == 555-555-5555 == 5555555555

    possible_phone_number = params["phone_number"]

    phone_number = ""
    digits = "1234567890"

    possible_phone_number.each_char do |c|
      if(digits.include? c) then
        phone_number = phone_number + c
      end
    end

    @correct_number_format = false

    if(phone_number.length == 10) then
      @correct_number_format = true
    end

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

      if(@valid_number) then

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
