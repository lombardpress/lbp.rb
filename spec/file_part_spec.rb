require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'file_part object' do
		
		require_relative "config_globals"
		paragraph1 = "l1-cpspfs"
		paragraph3 = "l1-shoatd"
		
		$paragraph = Lbp::FilePart.new("https://bitbucket.org/jeffreycwitt/lectio1/raw/master/lectio1.xml", "critical", $confighash, paragraph1)
		$div = Lbp::FilePart.new("https://bitbucket.org/jeffreycwitt/lectio1/raw/master/lectio1.xml", "critical", $confighash, paragraph1)
		$topdiv = Lbp::FilePart.new("https://bitbucket.org/jeffreycwitt/lectio1/raw/master/lectio1.xml", "critical", $confighash, "lectio1")

	it 'should return the pid for the Paragraph object' do 
		result = $paragraph.partid
		
		expect(result).to be_kind_of(String)
	end
	# it 'should return the number of the paragraph number' do 
	# 	result = $paragraph.number
	# 	expect(result).to be_kind_of(Integer)
	# end
	it 'should return the next paragraph object or nil if there are no more paragraphs' do
		result = $paragraph.next
		expect(result).to be_kind_of(Lbp::FilePart)
	end
	it 'should return the previous paragraph object or nil if there are no more paragraphs' do
		result = $paragraph.previous
		#this test works but I don't know how to write a test matching object or nil
		#expect(result).to be(Lbp::Paragraph || nil) 
	end
	it 'should return the plain text of the paragraph as a nokogiri object' do 
		result = $paragraph.transform_plain_text
		expect(result).to be_instance_of(Nokogiri::XML::NodeSet)
	end
	#it 'should return the plain text of the paragraph as a nokogiri object' do 
	#	result = $paragraph.transform_main_view
	#	expect(result).to be_instance_of(Nokogiri::XML::NodeSet)
	#end
	it 'should return the plain text of the topdiv as a nokogiri object' do 
		result = $topdiv.transform_plain_text
		expect(result).to be_instance_of(Nokogiri::XML::NodeSet)
	end
	it 'it should return the paragragraph as TEI XML an nokogiri node set' do 
		result = $paragraph.xml
		expect(result).to be_instance_of(Nokogiri::XML::NodeSet)
	end
	it 'it should return element name of element with xmlid' do
		result = $paragraph.element_name
		expect(result).to be_kind_of(String)
	end
	
end 