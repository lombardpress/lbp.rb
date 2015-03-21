require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'paragraph object' do
		require_relative "config_globals"
		paragraph1 = "l7-cmisir"
		#paragraph1 = "l7-seqgpe"
		position = 2

		filehash = {path: "https://bitbucket.org/jeffreycwitt/lectio7/raw/master/sorb_lectio7.xml", fs: "lectio7", ed: "master", type: "documentary", source: "origin", commentar_id: "plaoulcommentary"}		
		$paragraph_image = Lbp::ParagraphImage.new($confighash, filehash, paragraph1, position)

	it 'should return the ulx for the Paragraph Image object' do 
		result = $paragraph_image.ulx
		expect(result).to be_kind_of(Integer)
	end
	it 'should return the uly for the Paragraph Image object' do 
		result = $paragraph_image.uly
		expect(result).to be_kind_of(Integer)
	end
	it 'should return the lrx for the Paragraph Image object' do 
		result = $paragraph_image.lrx
		expect(result).to be_kind_of(Integer)
	end
	it 'should return the uly for the Paragraph Image object' do 
		result = $paragraph_image.lry
		expect(result).to be_kind_of(Integer)
	end
	it 'should return the width for the Paragraph Image object' do 
		result = $paragraph_image.width
		expect(result).to be_kind_of(Integer)
	end
	it 'should return the height for the Paragraph Image object' do 
		result = $paragraph_image.height
		expect(result).to be_kind_of(Integer)
	end
	it 'should return the url for the Paragraph Image object' do 
		result = $paragraph_image.url
		expect(result).to be_kind_of(String)
	end
	it 'should return the canvas for the Paragraph Image object' do 
		result = $paragraph_image.canvas
		expect(result).to be_kind_of(String)
	end
end
