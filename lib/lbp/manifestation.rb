require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'


module Lbp
	class Manifestation < Resource 
		
		#inherits initialization from Resource
		
		def transcriptions
			values("http://scta.info/property/hasTranscription")
		end
		def canonical_transcription
			value("http://scta.info/property/hasCanonicalTranscription")
			
		end
	end
end

		