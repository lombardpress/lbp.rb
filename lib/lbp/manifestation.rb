require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'


module Lbp
	class Manifestation < Resource 
		
		#inherits initialization from Resource
		
		def transcriptionUrls
			results = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasTranscription"))
			transcriptions = results.map {|m| m[:o].to_s}
			return transcriptions
		end
		def canonicalTranscriptionUrl
			transcriptionUrl = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasCanonicalTranscription")).first[:o].to_s
			return transcriptionUrl
		end
		def canonicalTranscription
			url = self.canonicalTranscriptionUrl
			transcriptionObj = Transcription.new(url)
			return transcriptionObj
		end
	end
end

		