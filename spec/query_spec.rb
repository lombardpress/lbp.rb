require 'lbp'
require 'pry'
require 'rdf'
require 'sparql'

describe 'query object' do

	require_relative "config_globals"

	$query_obj = Lbp::Query.new()	 

	it "should return result object from sparqle query" do 
		result = $query_obj.collection_query("<" + $commentary_url + ">")
		binding.pry
		expect(result).to be_kind_of(Array)
	end

end
