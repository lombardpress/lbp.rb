require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'item object' do 
	
	require_relative "config_globals"

	$itemobject = Lbp::Item.new($confighash, 'lectio1')

	it 'should return the filestem given at construction' do
		result = $itemobject.fs 
		expect(result).to be_kind_of(String)
	end

	it 'should return the full directory path of texts wherein all individual item directories are found' do 
		result = $itemobject.texts_dir 
		result.should == $confighash[:texts_dir]
	end

	it 'should return the full directory path of file' do 
		result = $itemobject.file_dir 
		result.should include($confighash[:texts_dir]) 
	end

	it 'should retrieve the item name from the TEI xml file' do 
		result = $itemobject.title
		expect(result).to be_kind_of(String)
	end
	it 'should return true when file is part of a git directory' do
		result = $itemobject.is_git_dir
		result.should == true 
	end
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
	it 'should return the sequence number of the item' do 
		result = $itemobject.order_number
		expect(result).to be_kind_of(Integer)
	end
	it 'should return an item of object of the previous item' do 
		result = $itemobject.previous
		expect(result).to be_instance_of(Lbp::Item)
	end
	it 'should return an item of object of the next item' do 
		result = $itemobject.next
		expect(result).to be_instance_of(Lbp::Item)
	end
end