require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'resource object' do 
	#TODO: database needs be changed so that shortID is "sententia"
	$resource_obj1 = Lbp::Resource.new("sentences")
	$resource_obj2 = Lbp::Resource.new("http://scta.info/resource/sententia")
	$resource_item = Lbp::Resource.new("lectio1")
	$resource_item2 = Lbp::Resource.new("pl-l1d1c1") #structureItem id
	$resource_item3 = Lbp::Resource.new("http://scta.info/resource/l1-acfefv") #paragraph url
	$resource_item3 = Lbp::Resource.new("l1-acfefv") #paragraph id
	$resource_div1 = Lbp::Resource.new("wdr-l1d1q1") #div short id
	$resource_div2 = Lbp::Resource.new("http://scta.info/resource/wdr-l1d1q1") #div url
	
	it 'returns type of resource from shortid' do 
		result = $resource_obj1.type_shortId
		expect(result).to be == "workGroup"
 	end
 	it 'returns type of resource id from url' do 
		result = $resource_obj2.type_shortId
		expect(result).to be == "workGroup"
 	end
 	it 'returns type of resource id from url' do 
		result = $resource_item.type_shortId
		expect(result).to be == "expression"
 	end
 	it 'returns type of resource id from url' do 
		result = $resource_item2.type_shortId
		expect(result).to be == "expression"
 	end
 	it 'returns type url of resource ' do 
		result = $resource_obj1.type
		expect(result).to be == "http://scta.info/resource/workGroup"
 	end
 	it 'returns title of resource ' do 
		result = $resource_obj1.title
		expect(result).to be == "Sentences Commentaries"
 	end
 	it 'returns structureType of resource ' do 
		result = $resource_item.structureType_shortId
		expect(result).to be == "structureItem"
 	end
 	it 'returns structureType of resource ' do 
		result = $resource_item2.structureType_shortId
		expect(result).to be == "structureItem"
 	end
 	it 'returns structureType of resource ' do 
		result = $resource_item3.structureType_shortId
		expect(result).to be == "structureBlock"
 	end
 	it 'returns structureType of resource ' do 
		result = $resource_item3.structureType
		expect(result).to be == "http://scta.info/resource/structureBlock"
 	end
 	it 'returns structureType of resource ' do 
		result = $resource_div1.structureType_shortId
		expect(result).to be == "structureDivision"
 	end
 	it 'returns structureType of resource ' do 
		result = $resource_div2.structureType_shortId
		expect(result).to be == "structureDivision"
 	end
end