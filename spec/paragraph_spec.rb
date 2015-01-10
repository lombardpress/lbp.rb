require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'paragraph object' do
		
		require_relative "config_globals"
		paragraph1 = "l1-cpspfs"
		paragraph3 = "l1-shoatd"
		$paragraph = Lbp::Paragraph.new($confighash, $filehash, paragraph1)

	it 'should return the pid for the Paragraph object' do 
		result = $paragraph.pid
		
		expect(result).to be_kind_of(String)
	end
	it 'should return the number of the paragraph number' do 
		result = $paragraph.number
		expect(result).to be_kind_of(Integer)
	end
	it 'should return the next paragraph object or nil if there are no more paragraphs' do
		result = $paragraph.next
		expect(result).to be_kind_of(Lbp::Paragraph)
	end
	it 'should return the previous paragraph object or nil if there are no more paragraphs' do
		result = $paragraph.previous
		#this test works but I don't know how to write a test matching object or nil
		#expect(result).to be(Lbp::Paragraph || nil) 
	end
	it 'should return the plain text of the paragraph as a nokogiri object' do 
		result = $paragraph.transform_plain_text
		binding.pry
		expect(result).to be_instance_of(Nokogiri::XML::NodeSet)
	end
	
end 