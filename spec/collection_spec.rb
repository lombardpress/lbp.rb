require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'collection object' do 
	require_relative "config_globals"
	
	$collection_obj = Lbp::Collection.new($projectfile)

	it 'should get list of item filestems in sequenced array' do 
		result = $collection_obj.item_filestems
		expect(result).to be_kind_of(Array)
 	end
 	it 'should get list of item objects in an array' do
 		result = $collection_obj.items
 		#reunning result.first.title returns ERROR!!!
 		expect(result).to be_kind_of(Array)
	end

	it 'should return local texts dir' do 
		result = $collection_obj.local_texts_dir
		expect(result).to be_kind_of(String)
	end

	it 'should return general repo directory' do 
		result = $collection_obj.git_repo
		
		expect(result).to be_kind_of(String)
	end
	it 'should return citation lists directory' do 
		result = $collection_obj.citation_lists_dir
		expect(result).to be_kind_of(String)
	end
	it 'should return xslt hash' do 
		result = $collection_obj.xslt_dirs

	expect(result).to be_kind_of(Hash)
	end
end