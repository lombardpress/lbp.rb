require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'paragraph object' do
	require_relative "config_globals"
	paragraph1 = "l7-cmisir"
	#paragraph1 = "l7-seqgpe"
	position = 2
	paragraphurl = "http://scta.info/text/plaoulcommentary/transcription/sorb_lectio7/paragraph/#{paragraph1}"
	$paragraph_image = Lbp::ParagraphImage.new(paragraphurl, position)

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
