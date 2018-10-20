require 'lbp'
require 'pry'
require 'rdf'
require 'sparql/client'

describe 'query object' do

	require_relative "config_globals"

	$query_obj = Lbp::Query.new()

	it "should run repeated sparql requests" do
		results = []

		counter = 0
		while counter < 100 do
			puts "query 1"
			result = $query_obj.collection_query("<" + $commentary_url + ">")
			results << result
			puts "waiting one second"
			sleep 1
			counter = counter + 1
		end

		expect(results).to be_kind_of(Array)
	end

end
