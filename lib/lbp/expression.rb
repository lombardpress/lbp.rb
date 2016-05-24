require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'




module Lbp
	class Expression < Resource 
		
		#inherits initialization from Resource
		
		def manifestationUrls
			results = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasManifestation"))
			manifestations = results.map {|m| m[:o].to_s}
			return manifestations
		end
		def canonicalManifestationUrl
			manifestation = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasCanonicalManifestation")).first[:o].to_s
			return manifestation
		end
		def canonicalManifestation
			url = self.canonicalManifestationUrl
			manifestationObj = Manifestation.new(url)
			return manifestationObj
		end
		def canonicalManifestation?
			if self.canonicalManifestationUrl == nil
				return false
			else
				return true
			end
		end
		# cannonical transcriptions refers to the canonical trancription 
		# of the canonical manifestation
		def canonicalTranscriptionUrl
			manifestationObj = self.canonicalManifestation
			url = manifestationObj.canonicalTranscriptionUrl
			return url
		end
		def canonicalTranscription
			url = self.canonicalTranscriptionUrl
			transcriptionObj = Transcription.new(url)
			return transcriptionObj
		end
		def canonicalTranscription?
			if self.canonicalManifestation? == false
				return false
			else
				if self.canonicalTranscriptionUrl == nil
					return false
				else
					return true
				end
			end
		end
		def transcriptionUrl(manifestationUrl)
			manifestationObj = Manifestation.new(manifestationUrl)
			transcriptionObj = manifestationObj.canonicalTranscriptionUrl 
			return transcriptionObj
		end
		def transcription(manifestationUrl)
			manifestationObj = Manifestation.new(manifestationUrl)
			transcriptionObj = manifestationObj.canonicalTranscription 
			return transcriptionObj
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
			## TODO: consider changing property so that there is more symmetry here
			if self.structureType_shortId == "structureBlock"
				ordernumber = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/paragraphNumber")).first[:o].to_s.to_i
			else
				ordernumber = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/totalOrderNumber")).first[:o].to_s.to_i
			end
			return ordernumber
		end
		def status
			status = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/status")).first[:o].to_s
		end

		def top_level_expression_url
			#TODO make sure this can handle different structure types
			status = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasTopLevelExpression")).first[:o].to_s
		end
		def top_level_expression_shortId
			self.top_level_expression_url.split("/").last
		end
		def top_level_expression
			expression = Expression.new(self.top_level_expression_url)
		end

		# connection properties
		#TODO: notice how all these return RDF::Solutions (or some RDF:: object)
		# rather already performing the conversion to strings as is done in all the above methods
		# this should be standardized
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