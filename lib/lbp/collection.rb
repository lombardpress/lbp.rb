require 'nokogiri'
require 'rugged'
require 'lbp/functions'


module Lbp
	class Collection
		#attr_reader :confighash
		def initialize(projectfile)
			#@confighash = self.confighash
			#@projectdatafile_dir = @confighash[:projectdatafile_dir]
			@projectfile = projectfile
		end

		 

		def local_texts_dir
			file = Nokogiri::XML(File.read(@projectfile))
			textdir = file.xpath(("//header/localTextsDirectory")).text
		end

		def citation_lists_dir
			file = Nokogiri::XML(File.read(@projectfile))
			citationlistdir = file.xpath(("//header/citationListsDirectory")).text
		end
		def git_repo
			file = Nokogiri::XML(File.read(@projectfile))
			gitrepo = file.xpath("//header/git_repo").text
		end
		

		def xslt_dirs
			#test change to hash
			@xslthash = Hash.new
			file = Nokogiri::XML(File.read(@projectfile))
			schemas = file.xpath("//header/xsltDirectories/schema")

			schemas.each do |schema| 
				schema_number = schema.attributes["version"].value 
				schema_default = schema.attributes["default"].value 
				@xslthash["#{schema_number}"] = {
					critical: schema.children.find {|child| child.name == "critical"}.text,
					documentary: schema.children.find {|child| child.name == "documentary"}.text,
					main_view: schema.children.find {|child| child.name == "main_view"}.text,
					index_view: schema.children.find {|child| child.name == "index_view"}.text,
					clean_view: schema.children.find {|child| child.name == "clean_view"}.text,
					plain_text: schema.children.find {|child| child.name == "plain_text"}.text,
					toc: schema.children.find {|child| child.name == "toc"}.text
				}
				if schema_default == 'true'
						@xslthash["default"] = {
						critical: schema.children.find {|child| child.name == "critical"}.text,
						documentary: schema.children.find {|child| child.name == "documentary"}.text,
						main_view: schema.children.find {|child| child.name == "main_view"}.text,
						index_view: schema.children.find {|child| child.name == "index_view"}.text,
						clean_view: schema.children.find {|child| child.name == "clean_view"}.text,
						plain_text: schema.children.find {|child| child.name == "plain_text"}.text,
						toc: schema.children.find {|child| child.name == "toc"}.text
					}
					end
					
			end
			return @xslthash
			
		end

		def confighash
			confighash = {
				local_texts_dir: self.local_texts_dir, 
				citation_lists_dir: self.citation_lists_dir, 
				xslt_dirs: self.xslt_dirs, 
				git_repo: self.git_repo}
		end

		def items
			file = Nokogiri::XML(File.read(@projectfile))
			result = file.xpath("//div[@id='body']//item/fileName/@filestem")
			fs_array = result.map do |fs| 
				Item.new(@projectfile, fs.value)
			end
			return fs_array
		end
		def item(fs)
			Item.new(@projectfile, fs)
		end

		def item_filestems
		####this commentated out section is preferred but is oddly not working for principia 	
		## ideally this commented code would replace the current code
			
			#items = self.items
			#item_filestems = items.map {|item| item.title}
			#return item_filestems
			file = Nokogiri::XML(File.read(@projectfile))
			result = file.xpath("//div[@id='body']//item/fileName/@filestem")

			fs_array = result.map do |fs| 
				fs.value
			end
			return fs_array
		end

	end
end
