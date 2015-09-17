// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

function display3gOr4g(){
		var value = $("#phone-type").children("option:selected").attr("value");
		value = parseInt(value);
		jQuery(".accesspoint-3g").css("display", "none");
		jQuery(".accesspoint-4g").css("display", "none");
		if(value == 1){
			jQuery(".accesspoint-3g").css("display", "inline");
		} else{
			jQuery(".accesspoint-4g").css("display", "inline");
		}
}

function displayPaymentInput(){
	var value = $("#payment-type").children("option:selected").attr("value");
	value = parseInt(value);
	jQuery("#refill-pin-input").css("display","none");
	jQuery("#plan-input").css("display","none");
	if(value == 1){
		jQuery("#refill-pin-input").css("display","inline");

	}else{

		jQuery("#plan-input").css("display","inline");
	}
}

jQuery(document).on('page:change', function() {
	//line needed to make dropdowns work
    $('.dropdown-toggle').dropdown();
    display3gOr4g();
    displayPaymentInput();

	jQuery( "input" ).focus(function() {
		$(".accesspoint-warning").css("display", "none");
  		$( this ).next( "span" ).css("display","inline");
  		console.log("focus");
	});

	jQuery("#phone-type").change(function(){

		display3gOr4g();

	});

	jQuery("#payment-type").change(function(){

		displayPaymentInput();
	});


$.ajax({
  dataType: 'jsonp',
  data: '',
  url: 'https://www.pagepluscellular.com/login/',
  success: function (data) {
  	
  }
});



});