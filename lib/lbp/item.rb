require 'nokogiri'
require 'rugged'
require 'lbp/functions'
require 'lbp/transcription'
require 'openssl'
require 'rdf'
require 'rdf/rdfxml'
require 'rdf/ntriples'

module Lbp
	class Item 
		attr_reader :url, :fs, :file_dir
		
		def initialize(confighash, url)
			
			@url = url
			@fs = url.split('/').last
			@commentary_id = url.split('/')[4]
			@resource = RDF::Resource.new(RDF::URI.new(@url))
			
			@graph = RDF::Graph.load(@resource)
      
      @data = @graph.data
      @confighash = confighash
      @texts_dir = @confighash[:local_texts_dir]
			@file_dir = @confighash[:local_texts_dir] + @fs + "/"

	  end
	  ### Item Header Extraction and Metadata Methods
		def title
			title = @data.query(:predicate => RDF::DC11.title).first.object.to_s
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
		def git_commit(message)
			repo = Rugged::Repository.new(@file_dir)
			puts message
			repo.inspect
			index = repo.index
			index.add_all
			index.write
			commit_tree = index.write_tree
			Rugged::Commit.create(repo, {message: message, parents: [repo.head.target], tree: commit_tree, update_ref: 'HEAD'})
		end
		#needs a test # not working yet
		#def git_push(username: nil, password: nil)
		#	credentials = self.git_username_password_credentials(username, password)
			
		#	remote = Rugged::Remote.lookup(@file_dir, 'origin')
			#repo.push(origin['refs/heads/master'], {credentials: credentials})
		#	repo.push('origin', {credentials: credentials})
		#end
		#needs a test
		def remove_local_dir
			FileUtils.rm_rf @file_dir
		end
		### End Git Methods ###
		### Begin Order Info ##

		# previous and next functions don't handle ends of arrays very well	
		# they also rely on the "item_filestems" methods which works but should be changed see comments in collection file
		#def previous
		#	sequence_array = Collection.new(@projectfile).item_filestems
			#if sequence_array[sequence_array.index(@fs) - 1 ] != nil
		#		previous_fs = sequence_array[sequence_array.index(@fs) - 1]
		#		previous_item = Item.new(@projectfile, previous_fs)
			#else
			#	previous_item = nil
			#end
		#	return previous_item
		#end
		#def next
		#	sequence_array = Collection.new(@projectfile).item_filestems
		#	#if sequence_array[@sequence_array.index(@fs) + 1 ] != nil
		#		next_fs = sequence_array[sequence_array.index(@fs) + 1]
		#		next_item = Item.new(@projectfile, next_fs)
			#else
			#	next_item = nil
			#end
		#	return next_item
		#end

		def order_number
			ordernumber = @data.query(:predicate => RDF::URI.new("http://scta.info/property/totalOrderNumber")).first.object.to_s.to_i
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
					file_path = "https://#{@confighash[:git_repo]}#{@fs}/raw/#{ed}/#{wit}_#{@fs}.xml"
				else
    			file_path = @file_dir + wit + "_" + @fs + ".xml"
    		end
    	end
    	return file_path
    end
    def file_hash(source: 'local', wit: 'critical', ed: 'master')
    	type = if wit == "critical" then "critical" else "documentary" end
    	filehash = {path: self.file_path(source: source, wit: wit, ed: ed), fs: @fs, ed: ed, type: type, source: source, commentary_id: @commentary_id}
			
			return filehash
    end
    
    def transcription(source: 'local', wit: 'critical', ed: 'master')
    	filehash = self.file_hash(source: source, wit: wit, ed: ed)
    	transcr = Transcription.new(@confighash, filehash)
		end	

		def transcription_slugs(source: 'local', ed: 'master')
			slug_array = []
			transcriptions = @data.query(:predicate => RDF::URI.new("http://scta.info/property/hasTranscription"))
			transcriptions.each do |transcription|
				slug_array << transcription.object.to_s.split("/").last
			end
			return slug_array
		end

		def transcriptions(source: 'local', ed: 'master')
			slug_array = self.transcription_slugs
			
			transcription_array = slug_array.map do |slug| 
				self.transcription(source: source, wit: slug, ed: ed)
			end
			
			#transcription_array << self.transcription(source: source, wit: 'critical', ed: ed)

			return transcription_array
		end

	end
end