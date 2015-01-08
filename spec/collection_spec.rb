require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'collection object' do 
	@confighash = { texts_dir: "/Users/JCWitt/WebPages/lbplib-testfiles/GitTextfiles/", 
		#texts_dir: "/Users/JCWitt/Documents/PlaoulProjectFiles/Textfiles/", 
		projectdatafile_dir: "/Users/JCWitt/WebPages/lbplib-testfiles/Conf/", 
		xslt_critical_dir: "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/public/pl_xslt_stylesheets/",
		xslt_documentary_dir: "/Users/JCWitt/WebPages/lbpwrapper/lombardpress/public/pl_xslt_stylesheets/", 
		xslt_main_view: "text_display.xsl",
		xslt_index_view: "text_display_index.xsl", 
		xslt_clean: "clean_forStatistics.xsl",
		xslt_plain_text: "plaintext.xsl", 
		xslt_toc: "lectio_outline.xsl"}
	
	$collection_obj = Lbp::Collection.new(@confighash)

	it 'should get list of item filestems in sequenced array' do 
		result = $collection_obj.item_filestems
		expect(result).to be_kind_of(Array)
 	end
 	it 'should get list of item objects in an array' do
 		result = $collection_obj.items
 		#reunning result.first.title returns ERROR!!!
 		expect(result).to be_kind_of(Array)
	end
end