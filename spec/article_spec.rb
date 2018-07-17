require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'article object' do
	$article_obj1 = Lbp::Resource.find("pp-about")
	$article_obj2 = Lbp::Resource.find("http://scta.info/resource/aw-bibliography")

	it 'returns type of resource' do
		result = $article_obj1.type.short_id
		expect(result).to be == "article"
 	end
 	it 'returns article type' do
		result = $article_obj1.article_type_shortId
		expect(result).to be == "about"
 	end
 	it 'returns article type' do
		result = $article_obj2.article_type_shortId
		expect(result).to be == "bibliography"
 	end

end
