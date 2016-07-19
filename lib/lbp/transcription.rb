require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'

module Lbp
	class Transcription < Resource
		#initionalization handled by Resource Class
		def file_path(branch="master")
			file_path = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasXML")).first[:o].to_s
			if branch != "master"
			file_path.gsub!("master", branch)
			end
			return file_path
		end
	  def transcription_type
	  	type = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/transcriptionType")).first[:o].to_s
	  	type.downcase
	  end

	  def file(confighash, branch="master")
	  	file = File.new(self.file_path(branch), self.transcription_type, confighash)
	  	return file
	  end
	  #NOTE: this really is a temporary method, since the database 
	  #should point to file corresponding to each transcription
	  #dynamically generated by the exist-db database.
	  # but this could remain in case it was useful to grab the part 
	  # from a file that would include a tei header etc.
	  def file_part(confighash, partid)
	  	file = FilePart.new(self.file_path, self.transcription_type, confighash, partid)
	  	return file
	  end
	end
end