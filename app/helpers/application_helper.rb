module ApplicationHelper

	def self.set_link(link,state,city)
		if state.nil? or city.nil?
			return link
		else
			l = link + "/" + state + "/" + city
			l2 = link + "_" + state + "_" + city
			return l2

		end
	end

	def self.phone_number?(phone_string)
		

	    phone_number = ""
	    digits = "1234567890"

	    phone_string.each_char do |c|
	      if(digits.include? c) then
	        phone_number = phone_number + c
	      end
	    end


	    if(phone_number.length == 10) then
	      return phone_number
	    else
	      return nil
	    end

	end
end
