require 'nokogiri'
require 'rugged'
require 'lbp/functions'
require 'lbp/transcription'

module Lbp
	class ItemGroup
		attr_reader :igid
		
		def initialize(projectfile, igid)
      @igid = igid
      @projectfile = projectfile
      
    end

    def items
			file = Nokogiri::XML(File.read(@projectfile))
			result = file.xpath("//div[@id='#{@igid}']//item/fileName/@filestem")
			fs_array = result.map do |fs| 
				Item.new(@projectfile, fs.value)
			end
			return fs_array
		end
		def item(fs)
			Item.new(@projectfile, fs)
		end
		def title
			file = Nokogiri::XML(File.read(@projectfile))
			result = file.xpath("//div[@id='#{@igid}']/head")
			return result.text
		end
		def has_sub_group?
			file = Nokogiri::XML(File.read(@projectfile))
			result = file.xpath("//div[@id='#{@igid}']//div")
			if result.count == 0
				false
			else
				true
			end
		end
		def has_parent_group?
			#I sort of hate this method. But it sort of works, though I can imagine problems.
			file = Nokogiri::XML(File.read(@projectfile))
			result = file.xpath("//div[@id='#{@igid}'][@class='toplevel']")
			if result.count == 0
				true
			else
				false
			end
		end
	end
end