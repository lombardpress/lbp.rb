require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'collection object' do 
	require_relative "config_globals"
	
	$collection_obj = Lbp::Collection.new($confighash)

	it 'should get list of item filestems in sequenced array' do 
		result = $collection_obj.item_filestems
		expect(result).to be_kind_of(Array)
 	end
 	it 'should get list of item objects in an array' do
 		result = $collection_obj.items
 		#reunning result.first.title returns ERROR!!!
 		expect(result).to be_kind_of(Array)
	end
end