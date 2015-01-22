require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'item group object' do 
=begin	
	require_relative "config_globals"
	
	$itemgroup = Lbp::ItemGroup.new($projectfile, "deFide")

	it 'should return the item group id input at initialization' do 
		result = $itemgroup.igid
		expect(result).to be_kind_of(String)
	end

	it 'should return an array of Item objects from with the Item group' do 
		result = $itemgroup.items
		expect(result).to be_kind_of(Array)
	end
	it 'should return an specific item object when a specific item group id is given' do
		result = $itemgroup.item('lectio1')
		expect(result).to be_kind_of(Lbp::Item)
	end
	it 'should return the title of the item group' do 
		result = $itemgroup.title
		expect(result).to be_kind_of(String)
	end
	it 'should return return true if the group has sub-groups and false if it does not' do 
		result = $itemgroup.has_sub_group?
		# not ideal because I would prefer the test to pass if the result is either false or true
		expect(result).to be false
	end
	it 'should return return true if the group has sub-groups and false if it does not' do 
		result = $itemgroup.has_parent_group?
		# not ideal because I would prefer the test to pass if the result is either false or true
		expect(result).to be false
	end
=end
end
