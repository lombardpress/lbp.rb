## this is a replacement file for transcription.rb 
## it should be renamed to transcription.rb 
## when the current transcription.rb file is no longer needed
require 'nokogiri'
#require 'lbp/functions'
#require 'lbp/item'
require 'open-uri'
require 'lbp'

module Lbp
	# class should be renamed to Transcription
	class File 
		attr_reader :xslt_dir, :file_path

		def initialize(filepath, transcription_type, confighash)
			@file_path = filepath
			@confighash = confighash
			@xslthash = @confighash[:xslt_dirs]

		  @type = transcription_type # critical or documentary

		  #xslt version needs to gathered from a method
		  xslt_version = nil
		  #for now its being set to nil because no documents currently declare it

	    if xslt_version == nil
	    	@schema = @xslthash["default"]
	   	else
	    	@schema = @xslthash[xslt_version]
	    end

	    if @type == 'critical' || @type == 'Critical'
	    	@xslt_dir = @schema[:critical]
	    elsif @type == 'documentary' || @type == 'Documentary' || @type == 'diplomatic'
	    	@xslt_dir = @schema[:documentary]
	  	end
	  end
		
		def file
			file = open(self.file_path)
			if self.file_path.include? "https://"
				#this is check for 200 is not working because bitbucket is redirecting to a error page 
				# I want to check forst if the request need authentication and the
				# only look for credentials the initial requests fails 
				#if file.status[0] != "200"
					file = open(self.file_path, {:http_basic_authentication => [@confighash[:git_username], @confighash[:git_password]]})
				#end
			end
			return file
		end
		def nokogiri
			xmldoc = Nokogiri::XML(self.file)
		end
		## End File Path Methods
		### Item Header Extraction and Metadata Methods
		def title
			xmldoc = self.nokogiri
			title = xmldoc.xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:titleStmt[1]/tei:title[1]", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return title.text
		end
		def author
			xmldoc = self.nokogiri
			author = xmldoc.xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc/tei:titleStmt[1]/tei:author", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return author.text
		end
		def editor
			xmldoc = self.nokogiri
			editor = xmldoc.xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc/tei:titleStmt[1]/tei:editor", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return editor.text
		end
		def ed_no
			xmldoc = self.nokogiri
			ed_no = xmldoc.at_xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:editionStmt[1]/tei:edition[1]/@n", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return ed_no.value
		end
		def ed_date
			xmldoc = self.nokogiri
			ed_date = xmldoc.at_xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:editionStmt[1]/tei:edition[1]/tei:date[1]/@when", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return ed_date.value
		end
		def pub_date
			xmldoc = self.nokogiri
			pub_date = xmldoc.at_xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:date[1]/@when", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return pub_date.value
		end
		def encoding_method
			xmldoc = self.nokogiri
			encoding_method = xmldoc.at_xpath("/tei:TEI/tei:teiHeader[1]/tei:encodingDesc[1]/tei:variantEncoding[1]/@method", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return encoding_method.value
		end
		def encoding_location
			xmldoc = self.nokogiri
			encoding_location = xmldoc.at_xpath("/tei:TEI/tei:teiHeader[1]/tei:encodingDesc[1]/tei:variantEncoding[1]/@location", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return encoding_location.value
		end
		def number_of_columns
			xmldoc = self.nokogiri
			test = xmldoc.xpath("//tei:pb", 'tei' => 'http://www.tei-c.org/ns/1.0')
			if @type == "critical"
				number_of_columns = nil
			elsif xmldoc.xpath("//tei:pb", 'tei' => 'http://www.tei-c.org/ns/1.0').count != 0
            number_of_columns = 1
      elsif xmldoc.xpath("//tei:cb", 'tei' => 'http://www.tei-c.org/ns/1.0').count != 0
           	number_of_columns = 2
      end
      return number_of_columns
    end

		### Begin transform (XSLT) methocs ###
		def transform(xsltfile, xslt_param_array=[])
			doc = xslt_transform(self.nokogiri, xsltfile, xslt_param_array)
    end
		def transform_apply(xsltfile, xslt_param_array=[])
			doc = xslt_apply_to(self.nokogiri, xsltfile, xslt_param_array)
    end
    def transform_main_view(xslt_param_array=[])
			xsltfile=@xslt_dir + @schema[:main_view] # "text_display.xsl"
			doc = self.transform_apply(xsltfile, xslt_param_array)
		end
		def transform_index_view(xslt_param_array=[])
			xsltfile=@xslt_dir + @schema[:index_view] # "text_display_index.xsl"
			doc = self.transform_apply(xsltfile, xslt_param_array)
		end
		def transform_clean(xslt_param_array=[])
    	xsltfile=@xslt_dir + @schema[:clean_view] # "clean_forStatistics.xsl"
    	doc = self.transform_apply(xsltfile, xslt_param_array)
    end
    def transform_clean_nokogiri(xslt_param_array=[])
    	xsltfile=@xslt_dir + @schema[:clean_view] # "clean_forStatistics.xsl"
    	doc = self.transform(xsltfile, xslt_param_array)
    end
		def transform_plain_text(xslt_param_array=[])
    	xsltfile=@xslt_dir + @schema[:plain_text] # "plaintext.xsl"
    	doc = self.transform_apply(xsltfile, xslt_param_array)
    end
    def transform_plain_text_nokogiri(xslt_param_array=[])
    	xsltfile=@xslt_dir + @schema[:plain_text] # "plaintext.xsl"
    	doc = self.transform(xsltfile, xslt_param_array)
    end
    def transform_json(xslt_param_array=[])
    	xsltfile=@xslt_dir + @schema[:json] # "plaintext.xsl"
    	doc = self.transform_apply(xsltfile, xslt_param_array)
    end
    def transform_toc(xslt_param_array=[])
    	xsltfile=@xslt_dir + @schema[:toc] # "lectio_outline.xsl"
    	doc = self.transform_apply(xsltfile, xslt_param_array)
    end
    ### End of Transformation Methods ###
    ### Begin Statistics Methods ###
    def word_count
    	plaintext = self.transform_plain_text
    	size = plaintext.split.size
    end
    def word_array
    	plaintext = self.transform_plain_text
    	word_array = plaintext.split
    	word_array.map!{ |word| word.downcase}
    end
    def word_frequency(sort, order)
    	word_array = self.word_array
    	wf = Hash.new(0)
			word_array.each { |word| wf[word] += 1 }
			
			if sort == "frequency" 
				if order == "descending" # high to low
					wf = wf.sort_by{|k,v| v}.reverse
				elsif order == "ascending" # low to high
					wf = wf.sort_by{|k,v| v}
				end
			elsif sort == "word"
				if order == "descending" # z - a
						wf = wf.sort_by{|k,v| k}.reverse
				elsif order == "ascending" #a - z
						wf = wf.sort_by{|k,v| k}
				end
			end
			return wf.to_h
    end
  end
end