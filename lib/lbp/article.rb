require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'
require 'rdf/vocab'
require 'lbp'

module Lbp
	class Article < Resource
		#initionalization handled by Resource Class
		def file_path
			file_path = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/hasXML")).first[:o].to_s
		end
	  def article_type
	  	type = self.results.dup.filter(:p => RDF::URI("http://scta.info/property/articleType")).first[:o].to_s
	  	type.downcase
	  end
	  def article_type_shortId
	  	self.article_type.split("/").last
	  end
	end
end
