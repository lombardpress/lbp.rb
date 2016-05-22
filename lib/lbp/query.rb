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
		    sparqlendpoint = "http://sparql.scta.info/ds/query"
		  elsif ENV['SPARQL'] == "local"
		  	sparqlendpoint = "http://localhost:3030/ds/query"
		  else
		    sparqlendpoint = "http://sparql.scta.info/ds/query"
		  end
			
			sparql = SPARQL::Client.new(sparqlendpoint)
		  result = sparql.query(query)

		  return result
		end
		def subject(url)
			query = "#{@prefixes}

          SELECT ?p ?o ?ptype
          {
          #{url} ?p ?o .
          OPTIONAL {
              ?p rdfs:subPropertyOf ?ptype .
              }

          }
          ORDER BY ?p
          "
      result = self.query(query)
		end 
		def subject_with_short_id(shortid)
			query = "#{@prefixes}

          SELECT ?p ?o ?ptype
          {
          ?resource <http://scta.info/property/shortId> '#{shortid}' .
          ?resource ?p ?o .
          OPTIONAL {
              ?p rdfs:subPropertyOf ?ptype .
              }

          }
          ORDER BY ?p
          "
      result = self.query(query)
		end 

		def zone_info(paragraphurl)
			query = "#{@prefixes}
				SELECT DISTINCT ?zone ?ulx ?uly ?lry ?lrx ?position ?height ?width ?canvasurl
	      {
	        #{paragraphurl} <http://scta.info/property/hasZone> ?zone .
	         ?zone <http://scta.info/property/ulx> ?ulx .
	         ?zone <http://scta.info/property/uly> ?uly .
	         ?zone <http://scta.info/property/lry> ?lry .
	         ?zone <http://scta.info/property/lrx> ?lrx .
	         ?zone <http://scta.info/property/position> ?position .
	         ?zone <http://scta.info/property/height> ?height .
	         ?zone <http://scta.info/property/width> ?width .
	         ?zone <http://scta.info/property/isZoneOn> ?canvasurl .
	      }
	      ORDER BY ?position"
			result = self.query(query)
		end


		def collection_query(collection_url)
			query = "#{@prefixes}
			
				SELECT ?collectiontitle ?title ?item ?questiontitle ?order ?status ?gitRepository
	      {
	        #{collection_url} <http://scta.info/property/hasStructureItem> ?item .
	        #{collection_url} <http://purl.org/dc/elements/1.1/title> ?collectiontitle .
	        ?item <http://purl.org/dc/elements/1.1/title> ?title  .
	        ?item <http://scta.info/property/totalOrderNumber> ?order .
	        ?item <http://scta.info/property/status> ?status .
	        ?item <http://scta.info/property/gitRepository> ?gitRepository .

	        
	        OPTIONAL
	      	{
	      	?item <http://scta.info/property/questionTitle> ?questiontitle  .
	      	}
	      }
	      ORDER BY ?order"
		  
		  result = self.query(query)
		end

		def item_query(expression_url)
			query = "#{@prefixes}

	      SELECT ?item_title ?transcript ?transcript_title ?transcript_status ?transcript_type ?manifestation
	      {
	      	#{expression_url} <http://purl.org/dc/elements/1.1/title> ?item_title .
	      	?manifestation <http://scta.info/property/isManifestationOf> #{expression_url} . 

	      	?transcript <http://scta.info/property/isTranscriptionOf> ?manifestation .
					?transcript <http://purl.org/dc/elements/1.1/title> ?transcript_title  .
	        ?transcript <http://scta.info/property/status> ?transcript_status .
	        ?transcript <http://scta.info/property/transcriptionType> ?transcript_type .
	      }"
			
			result = self.query(query)	        
			
		end
		def names(item_url)
		item_url = "<#{item_url}>"
			query = "#{@prefixes}
			
				SELECT ?item ?name ?nameTitle ?mentioningItem
	      {
	        #{item_url} <http://scta.info/property/mentions> ?name .
	        ?name <http://purl.org/dc/elements/1.1/title> ?nameTitle  .
	      }
	       	ORDER BY ?nameTitle
	       
	       "
	    result = self.query(query)
		end

		def quotes(item_url)
			item_url = "<#{item_url}>"
				query = "#{@prefixes}
				
					SELECT ?item ?quote ?quoteText ?quoteCitation
		      {
		        #{item_url} <http://scta.info/property/quotes> ?quote .
		        ?quote <http://scta.info/property/quotation> ?quoteText .
		        ?quote <http://scta.info/property/citation> ?quoteCitation .
		       }
		       ORDER BY ?quoteText
		       "
		    result = self.query(query)
		end
	end
end