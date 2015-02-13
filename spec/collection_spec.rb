require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'collection object' do 

	require_relative "config_globals"
	
	$collection_obj = Lbp::Collection.new($confighash, $commentary_url)

	it 'should get input url as String' do 
		result = $collection_obj.url
		expect(result).to be_kind_of(String)
 	end
 	it 'should get the title of the commentary as string' do 
 		result = $collection_obj.title
		expect(result).to be_kind_of(String)
 	end
 	it 'should return an array of item urls' do 
 		result = $collection_obj.item_urls
		expect(result).to be_kind_of(Array)
 	end
 	it 'should return the number of items' do 
 		result = $collection_obj.item_count
		expect(result).to be_kind_of(Integer)
 	end
 	it 'should return part urls within collection as array' do 
 		result = $collection_obj.part_urls
 		expect(result).to be_kind_of(Array)
 	end

end