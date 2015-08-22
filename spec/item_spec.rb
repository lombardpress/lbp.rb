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
		result = Lbp::Item.new($confighash, "http://scta.info/text/plaoulcommentary/item/lectio1").next
		expect(result).to be_kind_of(String)
	end
	it 'should return the nil for item that does not have a previous' do 
		result = Lbp::Item.new($confighash, "http://scta.info/text/plaoulcommentary/item/lectio134").next
		expect(result).to be_nil
	end
	it 'should return the url id of the previous item' do 
		result = Lbp::Item.new($confighash, "http://scta.info/text/plaoulcommentary/item/lectio1").previous
		expect(result).to be_kind_of(String)
	end
	it 'should return the nil for item that does not have a previous' do 
		result = Lbp::Item.new($confighash, "http://scta.info/text/plaoulcommentary/item/principiumI").previous
		expect(result).to be_nil
	end


	it 'should return true or false if item object hasTranscription' do 
		result = $itemobject.transcription?("reims")
		result.should == true || false
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
	it 'should return an string of url id' do 
		result = $itemobject.canonical_transcription
		expect(result).to be_kind_of(String)
	end


end