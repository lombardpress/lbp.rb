require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'item object' do 
	
	$confighash = { texts_dir: "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/pp-projectfiles/GitTextfiles/", 
		projectdatafile_dir: "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/pp-projectfiles/Conf/", 
		xslt_dir: "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/public/pl_xslt_stylesheets/", 
		xslt_main_view: "text_display.xsl",
		xslt_index_view: "text_display_index.xsl", 
		xslt_clean: "clean_forStatistics.xsl",
		xslt_plain_text: "plaintext.xsl", 
		xslt_toc: "lectio_outline.xsl"}

	$itemobject = Lbp::Item.new($confighash, 'lectio1')

	it 'should return the filestem given at construction' do
		result = $itemobject.fs 
		result.should == "lectio1"
	end

	it 'should return the full directory path of texts wherein all individual item directories are found' do 
		result = $itemobject.texts_dir 
		result.should == "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/pp-projectfiles/GitTextfiles/"
	end

	it 'should return the full directory path of file' do 
		result = $itemobject.file_dir 
		result.should == "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/pp-projectfiles/GitTextfiles/lectio1/"
	end

	it 'should return the full filename for an edited item' do
		result = $itemobject.file_path
		result.should == "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/pp-projectfiles/GitTextfiles/lectio1/lectio1.xml" 
	end

	it 'should return the full filename for a ms item' do
		result = $itemobject.file_path('reims')
		result.should == "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/pp-projectfiles/GitTextfiles/lectio1/reims_lectio1.xml" 
	end

	it 'should retrieve the item name from the TEI xml file' do 
		result = $itemobject.title
		result.should == "Lectio 1, de Fide" 
	end

	it 'should retrieve the author name from the TEI xml file' do 
		result = $itemobject.author
		result.should == "Petrus Plaoul" 
	end
	it 'should retrieve the editor name from the TEI xml file' do 
		result = $itemobject.editor
		result.should == "Jeffrey C. Witt" 
	end
	it 'should retrieve the edition number from TEI xml file' do 
		result = $itemobject.ed_no
		result.should == "2011.10-dev-master" 
	end
	it 'should retrieve the edition date from TEI xml file' do 
		result = $itemobject.ed_date
		result.should == "2011-10-04" 
	end
	it 'should retrieve the pubdate from TEI xml file' do 
		result = $itemobject.pub_date
		result.should == "2011-03-25" 
	end
	it 'should retrieve the encoding method from TEI xml file' do 
		result = $itemobject.encoding_method
		result.should == "parallel-segmentation" 
	end
	it 'should retrieve the encoding location from TEI xml file' do 
		result = $itemobject.encoding_location
		result.should == "internal" 
	end
	it 'should retrieve the number of columns based on presence of cb element and return 2' do 
		result = $itemobject.number_of_columns('svict')
		result.should == 2 
	end
	it 'should retrieve the number of columns based on presence of pb element and return 1' do 
		result = $itemobject.number_of_columns('erlang')
		result.should == 1 
	end
	it 'should return true when file is part of a git directory' do
		result = $itemobject.is_git_dir
		result.should == true 
	end
	it 'should return an array of branches' do
		result = $itemobject.git_branches
		expect(result).to be_instance_of(Array) 
		expect(result).to include("master")
	end
	it 'should return an array of tags' do
		result = $itemobject.git_tags
		expect(result).to be_instance_of(Array) 
		expect(result).to include("2011.10")
	end
	it 'should return the current branch' do
		result = $itemobject.git_current_branch
		expect(result).to be_instance_of(String) 
		#expect(result).to eq("master")
	end

	it 'should transform a doc using a specified xslt file' do
		xslt_param_array = []
		result = $itemobject.transform('edited', 'master', xslt_param_array, $confighash[:xslt_dir] + $confighash[:xslt_clean])
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
		result = $itemobject.transform_clean
		expect(result).to be_instance_of(Nokogiri::XML::Document)
	end
	it 'should process an xml doc with the text_display.xsl stylesheet' do 
		result = $itemobject.transform_toc
		expect(result).to be_instance_of(Nokogiri::XML::Document)
	end
	it 'should process an xml doc with the text_display.xsl stylesheet' do 
		result = $itemobject.transform_plain_text
		expect(result).to be_instance_of(Nokogiri::XML::Document)
	end
	it 'should get the word count of the item object' do 
		result = $itemobject.word_count
		#result.should eq(2122)
		expect(result).to be_kind_of(Integer)
	end
	it 'should get the word frequency of the item object' do 
		result = $itemobject.word_frequency("word", "ascending")
		expect(result).to be_kind_of(Hash)
	end
	it 'should get the paragraph count of the item object' do 
		result = $itemobject.number_of_body_paragraphs
		expect(result).to be_kind_of(Integer)
	end

	
end