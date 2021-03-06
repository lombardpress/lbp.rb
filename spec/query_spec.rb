require 'lbp'
require 'pry'
require 'rdf'
require 'sparql'

describe 'query object' do

	require_relative "config_globals"

	$query_obj = Lbp::Query.new()	 

	it "should return result object from sparqle query" do 
		result = $query_obj.collection_query("<" + $commentary_url + ">")
		expect(result).to be_kind_of(Array)
	end

	it "should return result object from item info query" do 
		result = $query_obj.item_query("<http://scta.info/resource/lectio1>")
		expect(result).to be_kind_of(Array)
	end

	it "should return result object from item expressionElement query" do 
		result = $query_obj.expressionElementQuery("http://scta.info/resource/plaoulcommentary", "http://scta.info/resource/structureElementName")
		expect(result).to be_kind_of(Array)
	end

end
