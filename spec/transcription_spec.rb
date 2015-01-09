require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'transcription object' do 
	
	require_relative "config_globals"
	$transcriptionobject = Lbp::Transcription.new($confighash, $filehash)

	it 'should return the filestem given at construction' do
		result = $transcriptionobject.fs 
		result.should == "lectio1"
	end

	it 'should return the full directory path of texts wherein all individual item directories are found' do 
		result = $transcriptionobject.texts_dir 
		result.should == "/Users/JCWitt/WebPages/lbplib-testfiles/GitTextfiles/"
	end

	it 'should return the full directory path of file' do 
		result = $transcriptionobject.file_dir 
		result.should == "/Users/JCWitt/WebPages/lbplib-testfiles/GitTextfiles/lectio1/"
	end

	it 'should return the full filename for an edited item' do
		result = $transcriptionobject.file_path
		result.should == "/Users/JCWitt/WebPages/lbplib-testfiles/GitTextfiles/lectio1/lectio1.xml" 
	end
=begin
	it 'should return the full filename for a ms item' do
		result = $itemobject.file_path('reims')
		result.should == "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/pp-projectfiles/GitTextfiles/lectio1/reims_lectio1.xml" 
	end
=end
	it 'should retrieve the item name from the TEI xml file' do 
		result = $transcriptionobject.title
		result.should == "Lectio 1, de Fide" 
	end

	it 'should retrieve the author name from the TEI xml file' do 
		result = $transcriptionobject.author
		result.should == "Petrus Plaoul" 
	end
	it 'should retrieve the editor name from the TEI xml file' do 
		result = $transcriptionobject.editor
		result.should == "Jeffrey C. Witt" 
	end
	it 'should retrieve the edition number from TEI xml file' do 
		result = $transcriptionobject.ed_no
		result.should == "2011.10-dev-master" 
	end
	it 'should retrieve the edition date from TEI xml file' do 
		result = $transcriptionobject.ed_date
		result.should == "2011-10-04" 
	end
	it 'should retrieve the pubdate from TEI xml file' do 
		result = $transcriptionobject.pub_date
		result.should == "2011-03-25" 
	end
	it 'should retrieve the encoding method from TEI xml file' do 
		result = $transcriptionobject.encoding_method
		result.should == "parallel-segmentation" 
	end
	it 'should retrieve the encoding location from TEI xml file' do 
		result = $transcriptionobject.encoding_location
		result.should == "internal" 
	end
=begin	
	it 'should retrieve the number of columns based on presence of cb element and return 2' do 
		result = $transcriptionobject.number_of_columns('svict')
		result.should == nil
	end
=end
=begin
	it 'should retrieve the number of columns based on presence of pb element and return 1' do 
		result = $itemobject.number_of_columns('erlang')
		result.should == 1 
	end
=end

	it 'should transform a doc using a specified xslt file' do
		xslt_param_array = []
		result = $transcriptionobject.transform($confighash[:xslt_critical_dir] + $confighash[:xslt_clean], xslt_param_array)
		
		expect(result).to be_instance_of(Nokogiri::XML::Document)
	end
	# This test should work, but include file paths break in XSL document
	#it 'should process an xml doc with the text_display.xslt stylesheet' do 
	#	result = $itemobject.transform._main_view
	#	expect(result).to be_instance_of(Nokogiri::XML::Document)
	#end
	#it 'should process an xml doc with the text_display.xsl stylesheet' do 
	#	result = $itemobject.transform_index_view
	#	expect(result).to be_instance_of(Nokogiri::XML::Document)
	#end
	it 'should process an xml doc with the text_display.xsl stylesheet' do 
		result = $transcriptionobject.transform_clean
		expect(result).to be_instance_of(Nokogiri::XML::Document)
	end
	it 'should process an xml doc with the text_display.xsl stylesheet' do 
		result = $transcriptionobject.transform_toc
		expect(result).to be_instance_of(Nokogiri::XML::Document)
	end
	it 'should process an xml doc with the text_display.xsl stylesheet' do 
		result = $transcriptionobject.transform_plain_text
		expect(result).to be_instance_of(Nokogiri::XML::Document)
	end
	it 'should get the word count of the item object' do 
		result = $transcriptionobject.word_count
		#result.should eq(2122)
		expect(result).to be_kind_of(Integer)
	end
	it 'should get the word frequency of the item object' do 
		result = $transcriptionobject.word_frequency("word", "ascending")

		expect(result).to be_kind_of(Hash)
	end
	it 'should get the paragraph count of the item object' do 
		result = $transcriptionobject.number_of_body_paragraphs
		
		expect(result).to be_kind_of(Integer)
	end
end