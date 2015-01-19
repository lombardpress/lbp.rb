require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'collection object' do 
	require_relative "config_globals"
	
	$collection_obj = Lbp::Collection.new($auto_pp_projectfile)

	it 'should get list of item filestems in sequenced array' do 
		result = $collection_obj.item_filestems
		expect(result).to be_kind_of(Array)
 	end
 	it 'should get a list of item names in sequenced array' do 
 		result = $collection_obj.item_titles
 		expect(result).to be_kind_of(Array)
 	end
 	it 'should return a hash of filestems and item names' do 
		result = $collection_obj.items_fs_title_hash
		expect(result).to be_kind_of(Hash)
	end
	it 'should return a hash of filestems and question titles' do 
		result = $collection_obj.items_fs_question_title_hash
		expect(result).to be_kind_of(Hash)
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
	it 'should return a specific item object when a specific item group id is given' do
		result = $collection_obj.item('lectio1')
		expect(result).to be_kind_of(Lbp::Item)
	end
	it 'should return the title of a given collection specified in the project data file' do 
		result = $collection_obj.title
		expect(result).to be_kind_of(String)
	end
	
	
end