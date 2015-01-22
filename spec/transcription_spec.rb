require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'transcription object' do 
	
	require_relative "config_globals"
	$transcriptionobject = Lbp::Transcription.new($confighash, $filehash)

	it 'should return the filestem given at construction' do
		result = $transcriptionobject.fs 
		expect(result).to be_kind_of(String)
	end

	it 'should return the full filename for an edited item' do
		result = $transcriptionobject.file_path
		expect(result).to be_kind_of(String)
	end

	it 'should return the File object for the given transcription' do 
		result = $transcriptionobject.file
		expect(result).to be_kind_of(File)
	end
	it 'should return the file from a public git repo' do 
		filehash = {path: "https://bitbucket.org/jeffreycwitt/lectio1/raw/master/lectio1.xml", fs: "lectio1", ed: "master", type: "critical", source: "origin", commentary_id: "plaoulcommentary"}
		transcriptionobject = Lbp::Transcription.new($confighash, filehash)
		result = transcriptionobject.file
		expect(result).to be_kind_of(Tempfile)
	end
	it 'should return the file from a private git repo' do 
		filehash = {path: "https://bitbucket.org/jeffreycwitt/lectio19/raw/master/lectio19.xml", fs: "lectio19", ed: "master", type: "critical", source: "origin", commentary_id: "plaoulcommentary"}
		transcriptionobject = Lbp::Transcription.new($confighash, filehash)
		result = transcriptionobject.file
		expect(result).to be_kind_of(Tempfile)
	end
	it 'should transform file from private git repository' do 
		filehash = {path: "https://bitbucket.org/jeffreycwitt/lectio19/raw/master/lectio19.xml", fs: "lectio19", ed: "master", type: "critical", source: "origin", commentary_id: "plaoulcommentary"}
		transcriptionobject = Lbp::Transcription.new($confighash, filehash)
		result = transcriptionobject.transform_clean
		expect(result).to be_kind_of(Nokogiri::XML::Document)
	end

	it 'should retrieve the item name from the TEI xml file' do 
		result = $transcriptionobject.title
		expect(result).to be_kind_of(String)
	end

	it 'should retrieve the author name from the TEI xml file' do 
		result = $transcriptionobject.author
		expect(result).to be_kind_of(String) 
	end
	it 'should retrieve the editor name from the TEI xml file' do 
		result = $transcriptionobject.editor
		expect(result).to be_kind_of(String) 
	end
	it 'should retrieve the edition number from TEI xml file' do 
		result = $transcriptionobject.ed_no
		expect(result).to be_kind_of(String) 
	end
	it 'should retrieve the edition date from TEI xml file' do 
		result = $transcriptionobject.ed_date
		expect(result).to be_kind_of(String) 
	end
	it 'should retrieve the pubdate from TEI xml file' do 
		result = $transcriptionobject.pub_date
		expect(result).to be_kind_of(String)
	end
	it 'should retrieve the encoding method from TEI xml file' do 
		result = $transcriptionobject.encoding_method
		expect(result).to be_kind_of(String) 
	end
	it 'should retrieve the encoding location from TEI xml file' do 
		result = $transcriptionobject.encoding_location
		expect(result).to be_kind_of(String) 
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
		result = $transcriptionobject.transform($confighash[:xslt_dirs]["default"][:critical] + $confighash[:xslt_dirs]["default"][:clean_view], xslt_param_array)
		
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
	it 'should process an xml doc with the cleanForStatistics.xsl stylesheet' do 
		file_path = $transcriptionobject.file_path
		nokogiri = $transcriptionobject.nokogiri
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
	it 'should return an array of paragraph objects' do
		result = $transcriptionobject.paragraphs
		
		expect(result).to be_kind_of(Array)
	end
	it 'should return an paragraph object for the named id' do
		result = $transcriptionobject.paragraph("l1-cpspfs")
		expect(result).to be_instance_of(Lbp::Paragraph)
	end
end