require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'



module Lbp
	class Expression < Resource 
		
		#inherits initialization from Resource
		
		def manifestations
			results = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasManifestation"))
			manifestations = results.map {|m| m[:o].to_s}
			return manifestations
		end
		def canonicalManifestation
			manifestation = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasCanonicalManifestation")).first[:o].to_s
			return manifestation
		end
		def canonicalTranscription
			manifestation = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasCanonicalTranscription")).first[:o].to_s
			return manifestation
		end
		def next
			unless self.results.dup.filter(:p => RDF::URI("http://scta.info/property/next")).count == 0
				next_expression = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/next")).first[:o].to_s
			else
				next_expression = nil
			end
			return next_expression
		end
		def previous
			unless self.results.dup.filter(:p => RDF::URI("http://scta.info/property/previous")).count == 0
				previous_expression = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/previous")).first[:o].to_s
			else
				previous_expression = nil
			end
			return previous_expression
		end
		def order_number
			ordernumber = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/totalOrderNumber")).first[:o].to_s.to_i
			return ordernumber
		end
		def status
			status = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/status")).first[:o].to_s
		end

		# connection properties
		def abbreviates
    	abbreviates = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/abbreviates"))
    end
    def abbreviatedBy
    	abbreviatedBy = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/abbreviatedBy"))
    end
    def references
    	references = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/references"))
    end
    def referencedBy
    	references = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/referencedBy"))
    end
    def copies
    	copies = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/copies"))
    end
    def copiedBy
    	copies = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/copiedBy"))
    end
    def mentions
    	mentions = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/mentions"))
    end
    def quotes
    	quotes = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/quotes"))
    end
    def quotedBy
    	quotedBy = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/quotedBy"))
    end

	end
end