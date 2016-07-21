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
			self.value("http://scta.info/property/structureType")
		end
		
		def manifestations # returns array of available manifestations as ResourceIdentifiers
			self.values("http://scta.info/property/hasManifestation")
			#results = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasManifestation"))
			#manifestations = results.map {|m| ResourceIdentifier.new(m[:o].to_s)}
			#return manifestations
		end
		def canonical_manifestation # returns a single manifestation ResourceIdentifier
			self.value("http://scta.info/property/hasManifestation")
			#manifestation_id = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasCanonicalManifestation")).first[:o].to_s
			#return ResourceIdentifier.new(manifestation_id)
		end
		
		def canonical_manifestation? # returns boolean
			if self.canonical_manifestation.to_s == nil
				return false
			else
				return true
			end
		end
		# cannonical transcriptions refers to the canonical trancription 
		# of the canonical manifestation
		def canonical_transcription # returns single transcription as ResourceIdentifier
			manifestation = self.canonical_manifestation
			# the object method is something I added to the resourceIdentifer
			# it creates the actually object resource. the creation of the object method
			# is useful because it involves a new db call and sometimes 
			# we only the manifest identifiers and don't need the whole db results.
			
			unless manifestation == nil
				return manifestation.object.canonical_transcription
			end
		end
		
		def canonical_transcription? #returns boolean
			if self.canonical_manifestation? == false
				return false
			else
				if self.canonical_transcription == nil
					return false
				else
					return true
				end
			end
		end
		## the next method doesn't seem necessary
		## if i know the manifestation id
		## I can just do Resource.find(manifestation_id).canonical_transcription

		#def transcription(manifestation_id)
		#	manifestation_object = Manifestation.find(manifestation_id)
		#	return manifestation_object.canonical_transcription
		#end
		
		# but a method called transcriptions, might be useful but computation intensive
		# it requires creating a manifestation object of each manifestation and then requesting
		# available transcriptions. If there are only 5 or 6 manifestations it might be ok
		# but if there are 100, that means 100 db calls

		def next # returns resource identifier of next expression or nil

			unless self.values("http://scta.info/property/next").count == 0 
				next_expression = self.value("http://scta.info/property/next")
			else
				next_expression = nil
			end
			return next_expression

			#unless self.results.dup.filter(:p => RDF::URI("http://scta.info/property/next")).count == 0
			#	next_expression = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/next")).first[:o].to_s
			#else
			#	next_expression = nil
			#end
			#return ResourceIdentifier.new(next_expression)
		end
		def previous #returns ResourceIdentifier
			unless self.values("http://scta.info/property/previous").count == 0 
				prev_expression = self.value("http://scta.info/property/previous")
			else
				prev_expression = nil
			end
			return prev_expression
			

			#unless self.results.dup.filter(:p => RDF::URI("http://scta.info/property/previous")).count == 0
			#	previous_expression = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/previous")).first[:o].to_s
			#else
			#	previous_expression = nil
			#end
			#return ResourceIdentifier.new(previous_expression)
		end
		def order_number # returns integer
			## TODO: consider changing property so that there is more symmetry here
			if self.structure_type.short_id == "structureBlock"
				# again note that the result of this query is not a uri but a literal
				# thus i'm not going to return a resource identifier but force the restult to be an integer
				ordernumber = self.value("http://scta.info/property/paragraphNumber").to_s.to_i
			else
				ordernumber = self.value("http://scta.info/property/totalOrderNumber").to_s.to_i
			end
			return ordernumber
		end
		def status #returns string
			#same comment as above
			status = self.value("http://scta.info/property/status").to_s
			#self.results.dup.filter(:p => RDF::URI("http://scta.info/property/status")).first[:o].to_s
		end

		def top_level_expression # returns resource identifier
			#TODO make sure this can handle different structure types
			return top_level_expression = self.value("http://scta.info/property/isPartOfTopLevelExpression")
		end
		def item_level_expression # returns resource identifier
			#TODO make sure this can handle different structure types
			return item_level_expression = self.value("http://scta.info/property/isPartOfStructureItem")
			ResourceIdentifier.new(item_level_expression)
		end
		def level # returns resource integer
			#same comment as earlier; this query does not actually return a uri, 
			#but an litteral. We need to make sure the resource identifer can handle that
			result = self.value("http://scta.info/property/level")
			unless self.results.count == 0 
				level = result.to_s.to_i
			else
				level = nil
			end
			return level
		end
		
		def abbreviates # returns array of ResourceIdentifiers
			self.values("http://scta.info/property/abbreviates")
    end
    def abbreviatedBy
    	self.values("http://scta.info/property/abbreviatedBy")
    end
    def references
    	self.values("http://scta.info/property/references")
    end
    def referencedBy
    	self.values("http://scta.info/property/referencesBy")
    end
    def copies
    	self.values("http://scta.info/property/copies")
    end
    def copiedBy
    	self.values("http://scta.info/property/copiedBy")
    end
    def mentions
    	self.values("http://scta.info/property/mentions")
    end
    def quotes
    	self.values("http://scta.info/property/quotes")
    end
    def quotedBy
    	self.values("http://scta.info/property/quotedBy")
    end

	end
end