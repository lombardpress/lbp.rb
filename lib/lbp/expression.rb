require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'


module Lbp
	class Expression < Resource 
		#inherits initialization from Resource

		def structure_type #returns resource identifier 
			value("http://scta.info/property/structureType")
		end
		def manifestations # returns array of available manifestations as ResourceIdentifiers
			values("http://scta.info/property/hasManifestation")
		end
		def canonical_manifestation # returns a single manifestation ResourceIdentifier
			value("http://scta.info/property/hasManifestation")
		end
		def canonical_manifestation? # returns boolean
			!canonical_manifestation.to_s.nil?
		end
		# cannonical transcriptions refers to the canonical trancription of the canonical manifestation
		def canonical_transcription # returns single transcription as ResourceIdentifier
			manifestation = canonical_manifestation
			unless manifestation == nil
				return manifestation.resource.canonical_transcription
			end
		end
		def canonical_transcription? #returns boolean
			!canonical_transcription.nil?
		end
		
		def next # returns resource identifier of next expression or nil
			value("http://scta.info/property/next")
		end
		def previous #returns ResourceIdentifier or nil
			value("http://scta.info/property/previous")
		end
		def order_number # returns integer
			## TODO: consider changing property so that there is more symmetry here
			if structure_type.short_id == "structureBlock"
				value("http://scta.info/property/paragraphNumber").to_s.to_i
			else
				value("http://scta.info/property/totalOrderNumber").to_s.to_i
			end
		end
		def status #returns string
			value("http://scta.info/property/status").to_s
		end
		def top_level_expression # returns resource identifier
			#TODO make sure this can handle different structure types
			value("http://scta.info/property/isPartOfTopLevelExpression")
		end
		def item_level_expression # returns resource identifier
			#TODO make sure this can handle different structure types
			value("http://scta.info/property/isPartOfStructureItem")
		end
		def level # returns resource integer
			#same comment as earlier; this query does not actually return a uri, 
			#but an litteral. We need to make sure the resource identifer can handle that
			value("http://scta.info/property/level").to_s.to_i
		end
		
		def abbreviates # returns array of ResourceIdentifiers
			values("http://scta.info/property/abbreviates")
    end
    def abbreviatedBy
    	values("http://scta.info/property/abbreviatedBy")
    end
    def references
    	values("http://scta.info/property/references")
    end
    def referencedBy
    	values("http://scta.info/property/referencesBy")
    end
    def copies
    	values("http://scta.info/property/copies")
    end
    def copiedBy
    	values("http://scta.info/property/copiedBy")
    end
    def mentions
    	values("http://scta.info/property/mentions")
    end
    def quotes
    	values("http://scta.info/property/quotes")
    end
    def quotedBy
    	values("http://scta.info/property/quotedBy")
    end

	end
end