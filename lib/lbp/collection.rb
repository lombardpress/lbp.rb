require 'nokogiri'
require 'lbp/functions'

module Lbp
	class Collection
		attr_reader :url 
		def initialize(confighash, url)
			
			@url = url
			@confighash = confighash
			
			@query = Query.new();
			@results = @query.subject("<" + url + ">");
      
		end

		def title
			#title = @data.query(:predicate => RDF::DC11.title).first.object.to_s
			title = @results.dup.filter(:p => RDF::URI(RDF::DC11.title)).first[:o].to_s
		end
		def slug()
			slug = @results.dup.filter(:p => RDF::URI("http://scta.info/property/slug")).first[:o].to_s
			#query = "SELECT ?slug {
			#	<#{@url}> <http://scta.info/property/slug> ?slug
			#}"
			#query_obj = Query.new
			#results = query_obj.query(query)
			#slug = results.first[:slug].to_s
			return slug
		end

		def item_urls
			
			items = []
			#results = @data.query(:predicate => RDF::URI.new("http://scta.info/property/hasItem"))
			results = @results.dup.filter(:p => RDF::URI("http://scta.info/property/hasItem"))
			results.each do |item| 
				items << item[:o].to_s
			end
			return items
		end
		def items
			#actually creating objects would reult in a separate http request for item - could overload the memory on my current server
		end
		def item_count
			self.item_urls.count
		end

		def part_urls
			parts = []
			#results = @data.query(:predicate => RDF::DC.hasPart)
			results = @results.dup.filter(:p => RDF::URI(RDF::DC.hasPart))
			results.each do |part| 
				parts << part[:o].to_s
			end
			return parts
		end
		def parts
			#actually creating objects would reult in a separate http request for part - could overload the memory on my current server
			#should just return a new sub collection
		end

		
	end
end