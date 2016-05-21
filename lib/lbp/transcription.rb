require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'

module Lbp
	class Transcription < Resource
		#initionalization handled by Resource Class
		def file_path
			file_path = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasXML")).first[:o].to_s
		end
	  def transcription_type
	  	type = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/transcriptionType")).first[:o].to_s
	  	type.downcase
	  end

	  def file(confighash)
	  	file = File.new(self.file_path, self.transcription_type, confighash)
	  	return file
	  end
	  def file_part(confighash, partid)
	  	file = FilePart.new(self.file_path, self.transcription_type, confighash, partid)
	  	return file
	  end
	end
end