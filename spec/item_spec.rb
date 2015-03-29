require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'item object' do 
	
	require_relative "config_globals"

	$itemobject = Lbp::Item.new($confighash, $scta_url)

	it 'should return the filestem given at construction' do
		result = $itemobject.fs 
		expect(result).to be_kind_of(String)
	end
	it 'should return the imput url' do 
		result = $itemobject.url
		expect(result).to be_kind_of(String)
	end
	it 'should retrieve the item name from the scta rdf graph' do 
		result = $itemobject.title
		expect(result).to be_kind_of(String)
	end

	it 'should return the full directory path of file' do 
		result = $itemobject.file_dir 
		expect(result).to be_kind_of(String)
	end
	it 'should return true when file is part of a git directory' do
		result = $itemobject.is_git_dir
		result.should == true 
	end
=begin	
	it 'should return an array of branches' do
		result = $itemobject.git_branches
		expect(result).to be_instance_of(Array) 
		expect(result).to include("master")
	end
	it 'should return an array of tags' do
		result = $itemobject.git_tags
		expect(result).to be_instance_of(Array) 
		expect(result).to include("2011.10")
	end
	it 'should return the current branch' do
		result = $itemobject.git_current_branch
		expect(result).to be_instance_of(String) 
		#expect(result).to eq("master")
	end
=end

	it 'should return the sequence number of the item' do 
		result = $itemobject.order_number
		expect(result).to be_kind_of(Integer)
	end
	it 'should return the url id of the next item' do 
		result = $itemobject.next
		# this is a bad test -- the result could also be nil
		expect(result).to be_kind_of(String)
	end
	it 'should return the url id of the previous item' do 
		result = $itemobject.previous
		
		# this is a bad test -- the result could also be nil
		expect(result).to be_kind_of(String)
	end




	it 'should return a transcription object' do 
		result = $itemobject.transcription
		expect(result).to be_instance_of(Lbp::Transcription)
	end
	it 'should return a file path for a specified transcription' do 
		result = $itemobject.file_path
		expect(result).to be_kind_of(String)
	end
	it 'should return a filehash' do 
		result = $itemobject.file_hash
		expect(result).to be_kind_of(Hash)
	end
	it 'should return an array of Transcriptions objects when transcriptions method is called' do 
		result = $itemobject.transcriptions
		expect(result).to be_kind_of(Array)
	end

end