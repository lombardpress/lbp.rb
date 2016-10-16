require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'


module Lbp
	class Surface < Resource
    def transcriptions
			values("http://scta.info/property/hasTranscription")
		end
    def isurfaces
			values("http://scta.info/property/hasISurface")
		end
    def canonical_isurface
			values("http://scta.info/property/hasCanonicalISurface")
		end
    def next # returns resource identifier of next expression or nil
			value("http://scta.info/property/next")
		end
		def previous #returns ResourceIdentifier or nil
			value("http://scta.info/property/previous")
		end
  end
end
