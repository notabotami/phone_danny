class PaymentNotifier < ActionMailer::Base
  default :from => "noreply@accesspoint.com"

  def purchase_email(description)

  	@description = description

    logger.tagged("mailer contact option") {logger.debug description}

    time = Time.new
    mail(:to => "blurgiamtrash@gmail.com", :subject => "The Accesspoint PURCHASE - " + " - " +time.strftime("%Y-%m-%d %H:%M:%S %Z") )
  end


end
