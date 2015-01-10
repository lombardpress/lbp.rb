require 'nokogiri'
require 'rugged'
require 'lbp/functions'
require 'lbp/transcription'

module Lbp
	class Item 
		attr_reader :fs, :texts_dir, :file_dir, :projectdatafile_dir, :xslt_dir
		
		def initialize(confighash, fs)
      @fs = fs
      
      @confighash = confighash
      @texts_dir = @confighash[:texts_dir]
			@file_dir = @confighash[:texts_dir] + @fs + "/"
      @projectdatafile_dir = @confighash[:projectdatafile_dir]
      

	  end
	  ### Item Header Extraction and Metadata Methods
		def title
			transcr = Transcription.new(@confighash, self.file_hash)
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
		### End Git Methods ###
		### Begin Order Info ##

		# previous and next functions don't handle ends of arrays very well	
		# they also rely on the "item_filestems" methods which works but should be changed see comments in collection file
		def previous
			sequence_array = Collection.new(@confighash).item_filestems
			#if sequence_array[sequence_array.index(@fs) - 1 ] != nil
				previous_fs = sequence_array[sequence_array.index(@fs) - 1]
				previous_item = Item.new(@confighash, previous_fs)
			#else
			#	previous_item = nil
			#end
			return previous_item
		end
		def next
			sequence_array = Collection.new(@confighash).item_filestems
			#if sequence_array[@sequence_array.index(@fs) + 1 ] != nil
				next_fs = sequence_array[sequence_array.index(@fs) + 1]
				next_item = Item.new(@confighash, next_fs)
			#else
			#	next_item = nil
			#end
			return next_item
		end
		def order_number
			sequence_array = Collection.new(@confighash).item_filestems
			array_number = sequence_array.index(@fs)
			sequence_number = array_number + 1
			return sequence_number
		end
		
		def file_path(source: 'local', wit: 'critical', ed: 'master')
			if wit == 'critical'
				if source == "origin"
					file_path = "https://#{@confighash[:git_repo]}#{@fs}/#{ed}/#{@fs}.xml"
				else
       		file_path = @file_dir + @fs + ".xml"
       	end
      else
      	if source == "origin"
					file_path = "http://#{@confighash[:git_repo]}#{@fs}/#{ed}/#{wit}_#{@fs}.xml"
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
    	transcr = Transcription.new(@confighash, filehash)
		end	
	end
end