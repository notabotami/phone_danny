//page_plus_activation logic goes here

function display3gOr4g(){
	//first have to initialize
	var value = $("#phone-type").children("option:selected").attr("value");
	value = parseInt(value);
	jQuery(".accesspoint-3g").css("display", "none");
	jQuery(".accesspoint-4g").css("display", "none");
	$(".3g-only").hide();
	$(".4g-only").hide();
	if(value == 1){
		jQuery(".accesspoint-3g").css("display", "inline");
		$(".3g-only").show();
	} else{
		jQuery(".accesspoint-4g").css("display", "inline");
		$(".4g-only").show();
	}

	//bind to change event
	jQuery("#phone-type").change(function(){
		var value = $("#phone-type").children("option:selected").attr("value");
		value = parseInt(value);
		jQuery(".accesspoint-3g").css("display", "none");
		jQuery(".accesspoint-4g").css("display", "none");
		$(".3g-only").hide();
		$(".4g-only").hide();
		$('#selectel-payment-plan option:eq(3)').prop('selected', true)

		if(value == 1){
			jQuery(".accesspoint-3g").css("display", "inline");
			$(".3g-only").show();
		} else{
			jQuery(".accesspoint-4g").css("display", "inline");
			$(".4g-only").show();
		}
	});
}

function displayPagePlusOrSelectel(){
	//first have to initialize
	var phone_service = $("#phone_service").attr("value");
	console.log(phone_service)
	if(phone_service == ("PagePlus")){
		$(".page-plus-only").show();
		$(".selectel-only").remove();
	}else{
		$(".page-plus-only").remove();
		$(".selectel-only").show();
	}
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

  //$(".stripe-button-el").hide();

	display3gOr4g();
	displayPagePlusOrSelectel();
	

	

});

