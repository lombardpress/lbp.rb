require 'nokogiri'
require 'rugged'
require 'lbp/functions'
require 'lbp/item'

module Lbp
	class Transcription 
		attr_reader :fs, :wit, :type, :ed, :filename_override, :texts_dir, :file_dir, :projectdatafile_dir, :xslt_dir

		def initialize(confighash, filehash)

	      @fs = filehash[:fs]
	      @wit = filehash[:wit] # i.e. critical, reims, svict, etc
	      @type = filehash[:type] # critical or documentary
	      @ed = filehash[:ed]
	      @filename_override = filehash[:filename_override] # should be optional, best if not set

	      @confighash = confighash
	      @texts_dir = @confighash[:texts_dir]
				@file_dir = @confighash[:texts_dir] + @fs + "/"
	      @projectdatafile_dir = @confighash[:projectdatafile_dir]
	      if @type == 'critical'
	      	@xslt_dir = @confighash[:xslt_critical_dir]
	      elsif @type == 'documentary'
	      	@xslt_dir = @confighash[:xslt_documentary_dir]
	      end

	      item = Item.new(@confighash, @fs)
  			@current_branch = item.git_current_branch
  			# the effort here is to only set instance variable when absolutely necessary
  			if @current_branch != @ed
  				@item = item
  			end
	  end
	  ## Begin file path methods
	  # Returns the absolute path of the file requested
	  def file_path
	  	if @filename_override != nil
	  		file_path = $filename_override
	  	elsif @wit == 'critical'
        file_path = @file_dir + @fs + ".xml"
      else
    		file_path = @file_dir + @wit + "_" + @fs + ".xml"
    	end
    	return file_path
		end
		def file
			file = File.open(self.file_path)
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

=begin - I think these methods belong with the Item or ItemRepo Object

    ### End Header and Metadata Information Extraction Methods ###
   	### Begin GIT functions ###
  	def is_git_dir
  		gitpath = @file_dir + ".git"
  		
  		if File.directory?(gitpath) 
  			true
  		else
  			false
  		end
  	end
  	def git_branches
  		repo = Rugged::Repository.new(@file_dir)
  		branches = repo.branches.map { |branch| branch.name }
		return branches
		end
		def git_current_branch
  		repo = Rugged::Repository.new(@file_dir)
  		current_branch = repo.head.name.gsub(%r!\Arefs/heads/(.*)\z!) { $1 }
  		return current_branch
  	end
  	def git_tags
  		repo = Rugged::Repository.new(@file_dir)
  		tags = repo.tags.map { |tag| tag.name }
		return tags
  	end
  	#need test for this 
  	def git_checkout(branch)
  		repo = Rugged::Repository.new(@file_dir)
  		repo.checkout(branch)
		end
		### End Git Methods ###
=end		
		### Begin transform (XSLT) methocs ###
		def transform (xsltfile, xslt_param_array=[])

  		xmlfile = self.file_path

  		if @current_branch != @ed
      	@item.git_checkout(@ed)
      		doc = xslt_transform(xmlfile, xsltfile, xslt_param_array)
      	@item.git_checkout(@current_branch);
      else
      	doc = xslt_transform(xmlfile, xsltfile, xslt_param_array)
      end
		end

		def transform_main_view(xslt_param_array=[])
			xsltfile=@xslt_dir + @confighash[:xslt_main_view] # "text_display.xsl"
			doc = self.transform(xsltfile, xslt_param_array=[])
		end
		def transform_index_view(xslt_param_array=[])
			xsltfile=@xslt_dir + @confighash[:xslt_index_view] # "text_display_index.xsl"
			doc = self.transform( xsltfile, xslt_param_array=[])
		end
		def transform_clean(xslt_param_array=[])
    	xsltfile=@xslt_dir + @confighash[:xslt_clean] # "clean_forStatistics.xsl"
    	doc = self.transform(xsltfile, xslt_param_array=[])
    end
		def transform_plain_text(xslt_param_array=[])
    	xsltfile=@xslt_dir + @confighash[:xslt_plain_text] # "plaintext.xsl"
    	doc = self.transform(xsltfile, xslt_param_array=[])
    end
    def transform_toc(xslt_param_array=[])
    	xsltfile=@xslt_dir + @confighash[:xslt_toc] # "lectio_outline.xsl"
    	doc = self.transform(xsltfile, xslt_param_array=[])
    end
    ### End of Transformation Methods ###
    ### Begin Statistics Methods ###
    def word_count
    	plaintext = self.transform_plain_text
    	size = plaintext.text.split.size
    end
    def word_array
    	plaintext = self.transform_plain_text
    	word_array = plaintext.text.split
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
    def number_of_body_paragraphs
			if @current_branch != @ed
  				@item.git_checkout(@ed)
      			xmldoc = self.nokogiri
						p = xmldoc.xpath("//tei:body//tei:p", 'tei' => 'http://www.tei-c.org/ns/1.0')
      		@item.git_checkout(@current_branch);
      else
      		xmldoc = self.nokogiri
					p = xmldoc.xpath("//tei:body//tei:p", 'tei' => 'http://www.tei-c.org/ns/1.0')
      end
      return p.count
		end
	end
end