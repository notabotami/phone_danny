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




jQuery(document).on('page:change', function() {
	//line needed to make dropdowns work
    $('.dropdown-toggle').dropdown();

    //hide stripe button so we can display ours
    //$(".stripe-button-el").hide();

    //bind payment button to click stripe button on click
    /*
    $("#pay_with_card").bind( "click", function() {
  		$(".stripe-button-el").click();
	   });
    */
    

	
    /*
    //display extra inormation within accesspoint-warning when focused
	jQuery( "input" ).focus(function() {
		$(".accesspoint-warning").css("display", "none");
  		$( this ).next( "span" ).css("display","inline");
  		console.log("focus");
	});
*/



/**
	jQuery("#payment-type").change(function(){

		displayPaymentInput();
	});
**/



});
