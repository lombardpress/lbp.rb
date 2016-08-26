require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'file object' do
	require_relative "config_globals"
	# schema 1.0.0 test file
	$fileobject = Lbp::File.new("https://bitbucket.org/jeffreycwitt/lectio1/raw/develop/lectio1.xml", "critical", $confighash)
	# schema 0.0.0 / default file
	$fileobject_private = Lbp::File.new("https://bitbucket.org/jeffreycwitt/lectio19/raw/master/lectio19.xml", "critical", $confighash)
	$fileobject3 = Lbp::File.new("https://bitbucket.org/jeffreycwitt/lectio1/raw/master/lectio1.xml", "critical", $confighash)
	$fileobject_with_null_config = Lbp::File.new("https://bitbucket.org/jeffreycwitt/lectio1/raw/master/lectio1.xml", "critical", nil)
	$file_from_transcription = Lbp::Resource.find("lectio1/critical/transcription").file

	it 'should return the full filename for an edited item' do
		result = $fileobject.file_path
		expect(result).to be_kind_of(String)
	end

	it 'should return the full filename for an edited item with null confighash' do
		result = $fileobject_with_null_config.file_path
		expect(result).to be_kind_of(String)
	end

	it 'should return the File object a given File' do
		result = $fileobject.file

		expect(result).to be_kind_of(Tempfile)
	end

	it 'should return the file from a private git repo' do
		result = $fileobject_private.file
		expect(result).to be_kind_of(Tempfile)
	end

	it 'should return the file from a git repo with null confighash' do
		result = $fileobject_with_null_config.file
		expect(result).to be_kind_of(Tempfile)
	end

	it 'should transform file from private git repository' do
		result = $fileobject_private.transform_clean
		expect(result).to be_kind_of(String)
	end

	it 'should retrieve the validating schema label from TEI xml file' do
		result = $fileobject.validating_schema_version
		expect(result).to be_kind_of(String)
	end

	it 'should retrieve the transcription type from the TEI xml file' do
		result = $fileobject.transcription_type_from_file
		expect(result).to be_kind_of(String)
	end

	it 'should retrieve the item name from the TEI xml file' do
		result = $fileobject.title
		expect(result).to be_kind_of(String)
	end

	it 'should retrieve the validating schema label from TEI xml file from existDB batabase using hasXML rather than hasDoc' do
		result = $file_from_transcription.title
		binding.pry
		expect(result).to be_kind_of(String)
	end

	it 'should retrieve the author name from the TEI xml file' do
		result = $fileobject.author
		expect(result).to be_kind_of(String)
	end

	it 'should retrieve the editor name from the TEI xml file' do
		result = $fileobject.editor
		expect(result).to be_kind_of(String)
	end


	it 'should retrieve the edition number from TEI xml file in a private git repo' do
		result = $fileobject_private.ed_no

		expect(result).to be_kind_of(String)
	end

	it 'should retrieve the edition date from TEI xml file' do
		result = $fileobject_private.ed_date
		expect(result).to be_kind_of(String)
	end

	it 'should retrieve the pubdate from TEI xml file' do
		result = $fileobject.pub_date
		expect(result).to be_kind_of(String)
	end

	# it 'should retrieve the encoding method from TEI xml file' do
	# 	result = $fileobject.encoding_method
	# 	expect(result).to be_kind_of(String)
	# end
	# it 'should retrieve the encoding location from TEI xml file' do
	# 	result = $fileobject.encoding_location
	# 	expect(result).to be_kind_of(String)
	# end

	it 'should transform a doc using a specified xslt file' do
		xslt_param_array = []
		result = $fileobject.transform($confighash[:xslt_base] + "default" + "/" + "critical" + "/" + $confighash[:stylesheets][:clean_view], xslt_param_array)

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
		result = $fileobject.transform_clean
		expect(result).to be_instance_of(String)
	end

	it 'should process an xml doc with the cleanForStatistics.xsl stylesheet and return as nokogiri object' do

		result = $fileobject.transform_clean_nokogiri
		expect(result).to be_instance_of(Nokogiri::XML::Document)
	end

# notworking missing file
#	it 'should process an xml doc with the text_display.xsl stylesheet' do
#		result = $fileobject.transform_toc
#		expect(result).to be_instance_of(String)
#	end

	it 'should process an xml doc with the plaintext.xsl stylesheet and return plaintext document' do
		result = $fileobject.transform_plain_text
		expect(result).to be_instance_of(String)
	end

	it 'should process an xml doc with the plaintext.xsl stylesheet and return nokogiri object of the plaintext document' do
		result = $fileobject.transform_plain_text_nokogiri
		expect(result).to be_instance_of(Nokogiri::XML::Document)
	end

	it 'should get the word count of the item object' do
		result = $fileobject.word_count
		#result.should eq(2122)
		expect(result).to be_kind_of(Integer)
	end
	it 'should get the word frequency of the item object' do
		result = $fileobject.word_frequency("word", "ascending")

		expect(result).to be_kind_of(Hash)
	end



end
