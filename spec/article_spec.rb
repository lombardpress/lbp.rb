require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'article object' do
	$article_obj1 = Lbp::Resource.find("http://scta.info/resource/aw-bibliography")
	$article_obj2 = Lbp::Resource.find("http://scta.info/resource/aw-bibliography")

	it 'returns type of resource' do
		result = $article_obj1.type.short_id
		expect(result).to be == "article"
 	end
 	# it 'returns article type' do
	# 	result = $article_obj1.article_type_shortId
	# 	expect(result).to be == "about"
 	# end
 	it 'returns article type' do
		result = $article_obj2.article_type_shortId
		expect(result).to be == "bibliography"
 	end
	it 'returns canoncical transcription' do
		result = $article_obj1.canonical_transcription.resource
		expect(result).to be_kind_of(Lbp::Transcription)
 	end
	it 'returns canoncical transcription' do
		result = $article_obj2.transcriptions
		expect(result).to be_kind_of(Array)
 	end
end
