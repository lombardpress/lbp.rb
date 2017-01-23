require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'resource object' do
	#TODO: database needs be changed so that shortID is "sententia"
	$resource_obj1 = Lbp::Resource.find("sententia")
	$resource_obj2 = Lbp::Resource.find("http://scta.info/resource/sententia")
	$resource_item = Lbp::Resource.find("lectio1")
	$resource_item2 = Lbp::Resource.find("pl-l1d1c1") #structureItem id
	$resource_item3 = Lbp::Resource.find("http://scta.info/resource/l1-acfefv") #paragraph url
	$resource_item3 = Lbp::Resource.find("l1-acfefv") #paragraph id
	$resource_div1 = Lbp::Resource.find("wdr-l1d1q1") #div short id
	$resource_div2 = Lbp::Resource.find("http://scta.info/resource/wdr-l1d1q1") #div url

	it 'return shortid of resource' do
		result = $resource_obj2.short_id
		expect(result).to be == "sententia"
 	end
 	it 'return urlid of resource' do
		result = $resource_obj1.url
		expect(result).to be == "http://scta.info/resource/sententia"
 	end
 	it 'returns type of resource from shortid' do
		result = $resource_obj1.type.short_id
		expect(result).to be == "workGroup"
 	end
 	it 'returns type of resource id from url' do
		result = $resource_obj2.type.short_id
		expect(result).to be == "workGroup"
 	end
 	it 'returns type of resource id from url' do
		result = $resource_item.type.short_id
		expect(result).to be == "expression"
 	end
 	it 'returns type of resource id from url' do
		result = $resource_item2.type.short_id
		expect(result).to be == "expression"
 	end
 	it 'returns type url of resource ' do
		result = $resource_obj1.type.url
		expect(result).to be == "http://scta.info/resource/workGroup"
 	end
 	it 'returns title of resource ' do
		result = $resource_obj1.title
		expect(result).to be == "Sentences Commentaries"
 	end
 	it 'returns parent part of resource ' do
		result = $resource_item.is_part_of
		expect(result).to be_kind_of(Lbp::ResourceIdentifier)
 	end
 	it 'returns child parts as array' do
 		resource = Lbp::Resource.find("lombardsententia")
		result = resource.has_parts
		expect(result).to be_kind_of(Array)
 	end
	it 'returns inbox for resource' do
		result = $resource_item.inbox
		expect(result.to_s).to be == "http://inbox.scta.info/notifications?resourceid=http://scta.info/resource/lectio1"
	end
end
