require 'nokogiri'
#require 'rugged'
require 'lbp/functions'
require 'lbp/transcription'
require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'

module Lbp
	class ParagraphExemplar 
		attr_reader :url, :pid, :cid
		
		def initialize(confighash, url)
			
			@url = url
			@pid = url.split('/').last
			@cid = url.split('/')[4]

#new insert 
			@query = Query.new();
			@results = @query.subject("<" + url + ">");
#new insert

	  end
	  ### Item Header Extraction and Metadata Methods
		def title
			#title = @data.query(:predicate => RDF::DC11.title).first.object.to_s
			title = @results.dup.filter(:p => RDF::URI(RDF::DC11.title)).first[:o].to_s
		end
		
		def next

			#unless @data.query(:predicate => RDF::URI.new("http://scta.info/property/next")) == nil
			unless @results.dup.filter(:p => RDF::URI("http://scta.info/property/next")).count == 0
				#next_item = @data.query(:predicate => RDF::URI.new("http://scta.info/property/next")).first.object.to_s
				next_item = @results.dup.filter(:p => RDF::URI("http://scta.info/property/next")).first[:o].to_s
			else
				next_item = nil
			end
			return next_item
		end
		def previous
			#unless @data.query(:predicate => RDF::URI.new("http://scta.info/property/previous")) == nil
			unless @results.dup.filter(:p => RDF::URI("http://scta.info/property/previous")).count == 0
				#previous_item = @data.query(:predicate => RDF::URI.new("http://scta.info/property/previous")).first.object.to_s
				previous_item = @results.dup.filter(:p => RDF::URI("http://scta.info/property/previous")).first[:o].to_s
			else
				previous_item = nil
			end
			return previous_item
		end

		def paragraph_number
			
			paragraph_number = @results.dup.filter(:p => RDF::URI("http://scta.info/property/paragraphNumber")).first[:o].to_s.to_i

		end


		def abbreviates
    	abbreviates = @results.dup.filter(:p => RDF::URI("http://scta.info/property/abbreviates"))
    end
    def abbreviatedBy
    	abbreviatedBy = @results.dup.filter(:p => RDF::URI("http://scta.info/property/abbreviatedBy"))
    end
    def references
    	references = @results.dup.filter(:p => RDF::URI("http://scta.info/property/references"))
    end
    def copies
    	copies = @results.dup.filter(:p => RDF::URI("http://scta.info/property/copies"))
    end
    def mentions
    	mentions = @results.dup.filter(:p => RDF::URI("http://scta.info/property/quotes"))
    end
    def quotes
    	quotes = @results.dup.filter(:p => RDF::URI("http://scta.info/property/quotes"))
    end
	
    ## transcription

    def transcriptions
    	transcriptions = @results.dup.filter(:p => RDF::URI("http://scta.info/property/hasTranscription"))
    end
    
	end
end