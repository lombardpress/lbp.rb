require 'nokogiri'
require 'rugged'
require 'lbp/functions'
require 'lbp/transcription'

module Lbp
	class Item 
		attr_reader :fs, :local_texts_dir, :file_dir, :projectfile, :xslt_dir
		
		def initialize(projectfile, fs)
      @fs = fs
      @projectfile = projectfile
      
      @confighash = Collection.new(projectfile).confighash
      @texts_dir = @confighash[:local_texts_dir]
			@file_dir = @confighash[:local_texts_dir] + @fs + "/"

	  end
	  ### Item Header Extraction and Metadata Methods
		def title
			transcr = Transcription.new(@projectfile, self.file_hash)
			transcr.title
		end
		
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
		def git_construct_remote_path
				remote_path = "https://#{@confighash[:git_repo]}#{@fs}.git";
		end
		
		def git_username_password_credentials(username, password) 
			Rugged::Credentials::UserPassword
			credentials = Rugged::Credentials::UserPassword.new(:username=>username, :password=>password)
			return credentials
			end
		#needs a test	
		def git_clone(username: nil, password: nil)
			remote_path = self.git_construct_remote_path
			Rugged::Repository.clone_at(remote_path, @file_dir, :credentials => self.git_username_password_credentials(username, password))
		end
		#nneds a test
		def git_pull(username: nil, password: nil)
			# not sure what the Rugged API is for this.
			# doesn't like this methods has been created 
			# for now it may have to be constructed from fetch and merge
			# or my method 'git_pull' could simply delete the existing repository and the re-lcone
				#this is is what i'm doing below, but it is not ideal
			self.remove_local_dir
			self.git_clone(username: username, password: password)
		end
		#needs a test
		def remove_local_dir
			FileUtils.rm_rf @file_dir
		end
		### End Git Methods ###
		### Begin Order Info ##

		# previous and next functions don't handle ends of arrays very well	
		# they also rely on the "item_filestems" methods which works but should be changed see comments in collection file
		def previous
			sequence_array = Collection.new(@projectfile).item_filestems
			#if sequence_array[sequence_array.index(@fs) - 1 ] != nil
				previous_fs = sequence_array[sequence_array.index(@fs) - 1]
				previous_item = Item.new(@projectfile, previous_fs)
			#else
			#	previous_item = nil
			#end
			return previous_item
		end
		def next
			sequence_array = Collection.new(@projectfile).item_filestems
			#if sequence_array[@sequence_array.index(@fs) + 1 ] != nil
				next_fs = sequence_array[sequence_array.index(@fs) + 1]
				next_item = Item.new(@projectfile, next_fs)
			#else
			#	next_item = nil
			#end
			return next_item
		end
		def order_number
			sequence_array = Collection.new(@projectfile).item_filestems
			array_number = sequence_array.index(@fs)
			sequence_number = array_number + 1
			return sequence_number
		end
		
		def file_path(source: 'local', wit: 'critical', ed: 'master')
			if wit == 'critical'
				if source == "origin"
					file_path = "https://#{@confighash[:git_repo]}#{@fs}/raw/#{ed}/#{@fs}.xml"
				else
       		file_path = @file_dir + @fs + ".xml"
       	end
      else
      	if source == "origin"
					file_path = "http://#{@confighash[:git_repo]}#{@fs}/raw/#{ed}/#{wit}_#{@fs}.xml"
				else
    			file_path = @file_dir + wit + "_" + @fs + ".xml"
    		end
    	end
    	return file_path
    end
    def file_hash(source: 'local', wit: 'critical', ed: 'master')
    	type = if wit == "critical" then "critical" else "documentary" end
    	filehash = {path: self.file_path(source: source, wit: wit, ed: ed), fs: @fs, ed: ed, type: type, source: source}
			
			return filehash
    end
    
    def transcription(source: 'local', wit: 'critical', ed: 'master')
    	filehash = self.file_hash(source: source, wit: wit, ed: ed)
    	transcr = Transcription.new(@projectfile, filehash)
		end	
		def transcriptions(source: 'local', ed: 'master')
			file = Nokogiri::XML(File.read(@projectfile))
			parts = file.xpath("//item[fileName/@filestem='#{@fs}']/hasParts/part/slug")
			transcription_array = parts.map do |part| 
				self.transcription(source: source, wit: part.text, ed: ed)
			end
			transcription_array << self.transcription(source: source, wit: 'critical', ed: ed)

			return transcription_array
		end
	end
end