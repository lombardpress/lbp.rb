require 'nokogiri'
require 'rugged'
require 'lbp/functions'

module Lbp
	class Item 
		attr_reader :fs, :texts_dir, :file_dir, :projectdatafile_dir, :xslt_dir

		def initialize(confighash, fs)
	      @fs = fs
	      @confighash = confighash
	      @texts_dir = @confighash[:texts_dir]

	      @file_dir = @confighash[:texts_dir] + @fs + "/"
	      @projectdatafile_dir = @confighash[:projectdatafile_dir]
	      @xslt_dir = @confighash[:xslt_dir]

	  end
	  # Returns the absolute path of the file requested
	  def file_path(ms='edited')
	  	if ms == 'edited'
        	file_path = @file_dir + @fs + ".xml"
      else
    		file_path = @file_dir + ms + "_" + @fs + ".xml"
    	end
    	return file_path
		end
		# returns the title specified in the TEI document
		def title(ms='edited')
			xmldoc = Nokogiri::XML(File.open(self.file_path(ms)))
			title = xmldoc.xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:titleStmt[1]/tei:title[1]", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return title.text
		end
		def author(ms='edited')
			xmldoc = Nokogiri::XML(File.open(self.file_path(ms)))
			author = xmldoc.xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc/tei:titleStmt[1]/tei:author", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return author.text
		end
		def editor(ms='edited')
			xmldoc = Nokogiri::XML(File.open(self.file_path(ms)))
			editor = xmldoc.xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc/tei:titleStmt[1]/tei:editor", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return editor.text
		end
		def ed_no(ms='edited')
			xmldoc = Nokogiri::XML(File.open(self.file_path(ms)))
			ed_no = xmldoc.at_xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:editionStmt[1]/tei:edition[1]/@n", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return ed_no.value
		end
		def ed_date(ms='edited')
			xmldoc = Nokogiri::XML(File.open(self.file_path(ms)))
			ed_date = xmldoc.at_xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:editionStmt[1]/tei:edition[1]/tei:date[1]/@when", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return ed_date.value
		end
		def pub_date(ms='edited')
			xmldoc = Nokogiri::XML(File.open(self.file_path(ms)))
			pub_date = xmldoc.at_xpath("/tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:date[1]/@when", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return pub_date.value
		end
		def encoding_method(ms='edited')
			xmldoc = Nokogiri::XML(File.open(self.file_path(ms)))
			encoding_method = xmldoc.at_xpath("/tei:TEI/tei:teiHeader[1]/tei:encodingDesc[1]/tei:variantEncoding[1]/@method", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return encoding_method.value
		end
		def encoding_location(ms='edited')
			xmldoc = Nokogiri::XML(File.open(self.file_path(ms)))
			encoding_location = xmldoc.at_xpath("/tei:TEI/tei:teiHeader[1]/tei:encodingDesc[1]/tei:variantEncoding[1]/@location", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return encoding_location.value
		end
		def number_of_columns(ms)
			xmldoc = Nokogiri::XML(File.open(self.file_path(ms)))
			test = xmldoc.xpath("//tei:pb", 'tei' => 'http://www.tei-c.org/ns/1.0')
			if xmldoc.xpath("//tei:pb", 'tei' => 'http://www.tei-c.org/ns/1.0').count != 0
            number_of_columns = 1
      elsif xmldoc.xpath("//tei:cb", 'tei' => 'http://www.tei-c.org/ns/1.0') != 0
           	number_of_columns = 2
      end
      return number_of_columns
    end
    	### GIT FUNCTIONS ###
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
		### XSLT transformation methods
		def transform_main_view(ms='edited', ed='master', xslt_param_array=[], xsltfile=@xslt_dir + "text_display.xsl")
  		xmlfile = self.file_path(ms)
  		current_branch = self.git_current_branch
  		if current_branch != ed
      	self.git_checkout(ed)
      		$doc = processXSLTDoc($xsltfile, $filename, $xsltParamArray);
      	self.git_checkout(current_branch);
      else
      	doc = xslt_transform(xmlfile, xsltfile, xslt_param_array)
      end
    end
    def transform_clean(ms='edited', ed='master', xslt_param_array=[], xsltfile=@xslt_dir + "clean_forStatistics.xsl")
    	xmlfile = self.file_path(ms)
  		current_branch = self.git_current_branch
  		if current_branch != ed
      	self.git_checkout(ed)
      		$doc = processXSLTDoc($xsltfile, $filename, $xsltParamArray);
      	self.git_checkout(current_branch);
      else
      	doc = xslt_transform(xmlfile, xsltfile, xslt_param_array)
      end
    end
  end
end