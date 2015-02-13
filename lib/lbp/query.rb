
require 'sparql'

module Lbp
	class Query
		
		def initialize
		
			@prefixes = "
	      PREFIX owl: <http://www.w3.org/2002/07/owl#>
	      PREFIX dbpedia: <http://dbpedia.org/ontology/>
	      PREFIX dcterms: <http://purl.org/dc/terms/>
	      PREFIX dc: <http://purl.org/dc/elements/1.1/>
	      PREFIX sctap: <http://scta.info/property/>
	      PREFIX sctar: <http://scta.info/resource/>
	      PREFIX sctat: <http://scta.info/text/>
	      PREFIX role: <http://www.loc.gov/loc.terms/relators/>
	      PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
	      PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
	      PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
	      "
    end
		def query(query)
		  if ENV['RACK_ENV'] == "production"
		    sparqlendpoint = "http://localhost:31867/ds/query"
		  else
		    sparqlendpoint = "http://localhost:3030/ds/query"
		  end
			
			sparql = SPARQL::Client.new(sparqlendpoint)
		  result = sparql.query(query)

		  return result
		end

		def collection_query(collection_url)
			query = "#{@prefixes}
			
				SELECT ?collectiontitle ?title ?item ?questiontitle ?order ?status
	      {
	        #{collection_url} <http://scta.info/property/hasItem> ?item .
	        #{collection_url} <http://purl.org/dc/elements/1.1/title> ?collectiontitle .
	        ?item <http://purl.org/dc/elements/1.1/title> ?title  .
	        ?item <http://scta.info/property/totalOrderNumber> ?order .
	        ?item <http://scta.info/property/status> ?status .
	        
	        OPTIONAL
	      	{
					?item <http://scta.info/property/questionTitle> ?questiontitle  .
	      	}
	      }
	      ORDER BY ?order"
		  
		  result = self.query(query)
		end

		def item_query(item_url)
			query = "#{@prefixes}

	      SELECT ?item_title ?transcript ?transcript_title ?transcript_status ?transcript_type
	      {
	        #{url} <http://purl.org/dc/elements/1.1/title> ?item_title .
	        #{url} <http://scta.info/property/hasTranscription> ?transcript .
	        ?transcript <http://purl.org/dc/elements/1.1/title> ?transcript_title  .
	        ?transcript <http://scta.info/property/status> ?transcript_status .
	        ?transcript <http://scta.info/property/transcriptionType> ?transcript_type .
	        
	      }"
			
			result = self.query(query)	        
			
		end
	end
end