require 'nokogiri'
require 'lbp/functions'

module Lbp
	class ParagraphImage
		attr_reader :pid 
		
		def initialize(confighash, filehash, pid, position=1)

			@confighash = confighash
			@filehash = filehash
			@pid = pid
			@position = position
			@pid_pointer = "#" + @pid
			
		end
		def info(xpathfragment)
			
			xmlobject = Transcription.new(@confighash, @filehash).nokogiri
			
			#this xpath will need to be revised when xml facsimile gets improved and reorganized
	  	result = xmlobject.xpath("/tei:TEI/tei:facsimile//tei:surface/tei:zone[@start='#{@pid_pointer}'][@n='#{@position}']/#{xpathfragment}", 'tei' => 'http://www.tei-c.org/ns/1.0')
	  	return result
		end
		def ulx
			ulx = self.info("@ulx")
			return ulx.first.value.to_i
		end
		def uly
			uly= self.info("@uly")
			return uly.first.value.to_i
		end
		def lrx
			lrx = self.info("@lrx")
			return lrx.first.value.to_i
		end
		def lry
			lry = self.info("@lry")
			return lry.first.value.to_i
		end
		def width
			width =  self.lrx - self.ulx
		end
		def height
			height = self.lry - self.uly
		end
		def url
			url = self.info("preceding-sibling::tei:graphic/@url")
			return url.first.value
		end
		def canvas
			return self.url.split(".").first
		end
	end
end