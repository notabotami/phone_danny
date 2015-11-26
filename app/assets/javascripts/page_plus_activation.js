//page_plus_activation logic goes here

function display3gOr4g(){
	//first have to initialize
	var value = $("#phone-type").children("option:selected").attr("value");
	value = parseInt(value);
	jQuery(".accesspoint-3g").css("display", "none");
	jQuery(".accesspoint-4g").css("display", "none");
	if(value == 1){
		jQuery(".accesspoint-3g").css("display", "inline");
	} else{
		jQuery(".accesspoint-4g").css("display", "inline");
	}

	//bind to change event
	jQuery("#phone-type").change(function(){
		var value = $("#phone-type").children("option:selected").attr("value");
		value = parseInt(value);
		jQuery(".accesspoint-3g").css("display", "none");
		jQuery(".accesspoint-4g").css("display", "none");
		if(value == 1){
			jQuery(".accesspoint-3g").css("display", "inline");
		} else{
			jQuery(".accesspoint-4g").css("display", "inline");
		}
	});
}

function auto_fill_forms(){
	$('form').on("ajax:error", function(e,data,status,xhr){
		console.log("Inside auto_fill_forms!");
	});
}

function  setupForms(){
	$('form').submit(function(){
		var valuesToSubmit = $(this).serialize();
		$.ajax({
			type: "POST",
			url: $(this).attr("action"),
			data: valuesToSubmit,
			dataType: "JSON"
		}).success(function(json){
			console.log(json.goodies);
		}).error(function(json){
			console.log( json.responseJSON);
		});

		return false; //prevents normal behavior
	});
}


jQuery(document).on('page:change', function() {


	display3gOr4g();
	//setupForms();

	

});

/**
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

      @valid_number = false

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


        respond_to do |format|
          format.html 
          format.js {} 
          format.json {}
        end



      end
    end
  end
  **/
