require 'nokogiri'
require 'lbp/functions'

module Lbp
	class ParagraphImage
		attr_reader :pid 
		
		#def initialize(confighash, filehash, pid, position=1)
		def initialize(paragraphurl, position=1)
			@query = Query.new();
			@results = @query.zone_info("<" + paragraphurl + ">")
			@zone_index = position - 1
		end
		def ulx
			return @results[@zone_index][:ulx].to_s.to_i
		end
		def uly
			return @results[@zone_index][:uly].to_s.to_i
		end
		def lrx
			return @results[@zone_index][:lrx].to_s.to_i
		end
		def lry
			return @results[@zone_index][:lry].to_s.to_i
		end
		def width
			return @results[@zone_index][:width].to_s.to_i
		end
		def height
			return @results[@zone_index][:height].to_s.to_i
		end
		def url
			return @results[@zone_index][:canvasurl].to_s.split("/").last + ".jpg"
		end
		def canvas
			return @results[@zone_index][:canvasurl].to_s.split("/").last
		end
	end
end