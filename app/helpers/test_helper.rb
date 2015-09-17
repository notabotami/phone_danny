module TestHelper

	def self.get_page_numbers(current_page,total_pages)

		
		if current_page == 1 or current_page == 2 or current_page == 3 then
			return [2,3,4,5,6]
		elsif current_page == total_pages or current_page == (total_pages - 1) or current_page == (total_pages - 2) then
			return [total_pages-5,total_pages-4,total_pages-3,total_pages-2,total_pages-1]

		else
			return [current_page-2,current_page-1,current_page,current_page+1,current_page+2]
		end
			
	end

	def self.right_ellipses?(current_page,total_pages)
		if current_page == total_pages or current_page == (total_pages - 1) or current_page == (total_pages - 2) or current_page == (total_pages - 3) then
			return false

		else
			return true

		end
	end

	def self.left_ellipses?(current_page)
		if current_page == 1 or current_page == 2 or current_page == 3  or current_page == 4 then
			return false
		else
			return true
		end

	end

end