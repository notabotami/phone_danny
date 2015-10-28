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
end
