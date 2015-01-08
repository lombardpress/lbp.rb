require 'nokogiri'
require 'rugged'
require 'lbp/functions'


module Lbp
	class Collection
		attr_reader :confighash
		def initialize(confighash)
			@confighash = confighash
			@projectdatafile_dir = @confighash[:projectdatafile_dir]
		end
		def items
			file = Nokogiri::XML(File.read(@projectdatafile_dir + "projectdata.xml"))
			result = file.xpath("//div[@id='body']//item/fileName/@filestem")
			fs_array = result.map do |fs| 
				Item.new(@confighash, fs.value)
			end
			return fs_array
		end
		def item_filestems
		####this commentated out section is preferred but is oddly not working for principia 	
		## ideally this commented code would replace the current code
			
			#items = self.items
			#item_filestems = items.map {|item| item.title}
			#return item_filestems
			file = Nokogiri::XML(File.read(@projectdatafile_dir + "projectdata.xml"))
			result = file.xpath("//div[@id='body']//item/fileName/@filestem")
			fs_array = result.map do |fs| 
				fs.value
			end
			return fs_array
		end
	end
end
