require 'spec_helper'
require 'lbp'
require 'pry'


describe 'expression object' do 
	#TODO: database needs be changed so that shortID is "sententia"
	$resource_obj1 = Lbp::Expression.new("sentences")
	$resource_obj2 = Lbp::Expression.new("http://scta.info/resource/sententia")
	$resource_item = Lbp::Expression.new("lectio1")
	$resource_itemFirstInSequence = Lbp::Expression.new("principiumI")
	$resource_itemLastInSequence = Lbp::Expression.new("lectio134")
	$resource_item2 = Lbp::Expression.new("pl-l1d1c1") #structureItem id
	$resource_item3 = Lbp::Expression.new("http://scta.info/resource/l1-acfefv") #paragraph url
	$resource_para = Lbp::Expression.new("l1-acfefv") #paragraph id
	$resource_div1 = Lbp::Expression.new("wdr-l1d1q1") #div short id
	$resource_div2 = Lbp::Expression.new("http://scta.info/resource/wdr-l1d1q1") #div url
	
	it 'returns array of manifestations for given expression at the structureItem level' do 
		result = $resource_item.manifestationUrls
		expect(result).to be_kind_of(Array)
 	end
 	it 'returns array of manifestations for given expression structureBlock level' do 
		result = $resource_para.manifestationUrls
		expect(result).to be_kind_of(Array)
 	end
 	it 'returns type of resource id from url to check inheritance from Resource Class' do 
		result = $resource_item.type_shortId
		expect(result).to be == "expression"
 	end
 	it 'returns canonical manifestation' do 
		result = $resource_item.canonicalManifestationUrl
		expect(result).to be == "http://scta.info/resource/lectio1/critical"
 	end
 	it 'returns canonical transcription' do 
		result = $resource_item.canonicalTranscriptionUrl
		expect(result).to be == "http://scta.info/resource/lectio1/critical/transcription"
	end
	it 'returns status of expression' do 
		result = $resource_item.status
	
		expect(result).to be_kind_of(String)
	end
	it 'returns next expression at the same (structureItem) level' do 
		result = $resource_item.next
		expect(result).to be_kind_of(String)
	end
	it 'returns null for expression next request when expression is last in the series' do 
		result = $resource_itemLastInSequence.next
		expect(result).to be == nil
	end
	it 'returns previous expression at the same (structureItem) level' do 
		result = $resource_item.previous
		expect(result).to be_kind_of(String)
	end
	it 'returns null for expression previous request when expression is first in the series' do 
		result = $resource_itemLastInSequence.next
		expect(result).to be == nil
	end
	it 'returns next expression at the same (structureBlock) level' do 
		result = $resource_para.next
		expect(result).to be_kind_of(String)
	end
	it 'returns previous expression at the same (structureBlock) level' do 
		result = $resource_para.previous
		expect(result).to be_kind_of(String)
	end

end