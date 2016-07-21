require 'spec_helper'
require 'lbp'
require 'pry'


describe 'expression object' do 
	#TODO: database needs be changed so that shortID is "sententia"
	$resource_obj1 = Lbp::Resource.find("sentences")
	$resource_obj2 = Lbp::Resource.find("http://scta.info/resource/sententia")
	$resource_item = Lbp::Resource.find("lectio1")
	$resource_toplevelexpression = Lbp::Resource.find("plaoulcommentary")
	$resource_itemFirstInSequence = Lbp::Resource.find("principiumI")
	$resource_itemLastInSequence = Lbp::Resource.find("lectio134")
	$resource_item2 = Lbp::Resource.find("pl-l1d1c1") #structureItem id
	$resource_item3 = Lbp::Resource.find("http://scta.info/resource/l1-acfefv") #paragraph url
	$resource_para = Lbp::Resource.find("l1-acfefv") #paragraph id
	$resource_div1 = Lbp::Resource.find("wdr-l1d1q1") #div short id
	$resource_div2 = Lbp::Resource.find("http://scta.info/resource/wdr-l1d1q1") #div url
	
	it 'returns array of manifestations for given expression at the structureItem level' do 
		result = $resource_item.manifestations
		expect(result).to be_kind_of(Array)
 	end
 	#it 'returns array of manifestations for given expression structureBlock level' do 
	#	result = $resource_para.manifestation
	#	expect(result).to be_kind_of(Array)
 	#end
 	it 'returns type of resource id from url to check inheritance from Resource Class' do 
		result = $resource_item.type.short_id
		expect(result).to be == "expression"
 	end
 	it 'returns canonical manifestation' do 
		result = $resource_item.canonical_manifestation.url
		expect(result).to be == "http://scta.info/resource/lectio1/critical"
 	end
 	it 'returns canonical transcription' do 
		result = $resource_item.canonical_transcription.url
		expect(result).to be == "http://scta.info/resource/lectio1/critical/transcription"
	end
	it 'returns true or false for presence of canonical Transcription' do 
		result = $resource_item.canonical_transcription?
		expect(result).to be == true
	end
	
	# need to revisit this test; test made be failing because of bad data, not bad code
	
	#it 'returns false for presence of canonical Transcription' do 
	#	$resource_without_transcript_started = Lbp::Resource.find("b3-q2")
		
	#	result = $resource_without_transcript_started.canonical_transcription?
	#	expect(result).to be == false
	#end
	
	it 'returns status of expression' do 
		result = $resource_item.status
		expect(result).to be_kind_of(String)
	end
	it 'returns next expression at the same (structureItem) level' do 
		result = $resource_item.next.url
		expect(result).to be_kind_of(String)
	end
	it 'returns null for expression next request when expression is last in the series' do 
		result = $resource_itemLastInSequence.next
		expect(result).to be == nil
	end
	it 'returns previous expression at the same (structureItem) level' do 
		result = $resource_item.previous.url
		expect(result).to be_kind_of(String)
	end
	it 'returns null for expression previous request when expression is first in the series' do 
		result = $resource_itemFirstInSequence.previous
		expect(result).to be == nil
	end
	it 'returns next expression at the same (structureBlock) level' do 
		result = $resource_para.next.url
		expect(result).to be_kind_of(String)
	end
	it 'returns previous expression at the same (structureBlock) level' do 
		result = $resource_para.previous.url
		expect(result).to be_kind_of(String)
	end
	it 'returns top level expression for expression resource' do 
		result = $resource_para.top_level_expression.url
		expect(result).to be_kind_of(String)
	end
	it 'returns top level expression for expression resource' do 
		result = $resource_item.top_level_expression.url
		expect(result).to be_kind_of(String)
	end
	it 'returns top level expression for expression resource' do 
		result = $resource_item.top_level_expression.short_id
		expect(result).to be_kind_of(String)
	end
	it 'returns the level integer from the expression' do 
		result = $resource_toplevelexpression.level
		expect(result).to be_kind_of(Integer)
	end

	it 'returns structureType of resource ' do 
		result = $resource_item.structure_type.short_id
		expect(result).to be == "structureItem"
 	end
 	it 'returns structureType of resource ' do 
		result = $resource_item2.structure_type.short_id
		expect(result).to be == "structureItem"
 	end
 	it 'returns structureType of resource ' do 
		result = $resource_item3.structure_type.short_id
		expect(result).to be == "structureBlock"
 	end
 	it 'returns structureType of resource ' do 
		result = $resource_item3.structure_type.url
		expect(result).to be == "http://scta.info/resource/structureBlock"
 	end
 	it 'returns structureType of resource ' do 
		result = $resource_div1.structure_type.short_id
		expect(result).to be == "structureDivision"
 	end
 	it 'returns structureType of resource ' do 
		result = $resource_div2.structure_type.short_id
		expect(result).to be == "structureDivision"
 	end

end