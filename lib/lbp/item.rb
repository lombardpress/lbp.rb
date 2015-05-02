require 'nokogiri'
#require 'rugged'
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

#new insert 
			@query = Query.new();
			@results = @query.subject("<" + url + ">");
#new insert

#deletion
			#@resource = RDF::Resource.new(RDF::URI.new(@url))
			#@graph = RDF::Graph.load(@resource)
      #@data = @graph.data
#deletion
      
      @confighash = confighash
      @texts_dir = @confighash[:local_texts_dir]
			@file_dir = @confighash[:local_texts_dir] + @fs + "/"

	  end
	  ### Item Header Extraction and Metadata Methods
		def title
			#title = @data.query(:predicate => RDF::DC11.title).first.object.to_s
			title = @results.dup.filter(:p => RDF::URI(RDF::DC11.title)).first[:o].to_s
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
=begin  	
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
=end		
		def git_construct_remote_path
				remote_path = "https://#{@confighash[:git_repo]}#{@fs}.git";
		end
=begin		
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
		#needs a test
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

=end		
		### Begin Order Info ##

		def next

			#unless @data.query(:predicate => RDF::URI.new("http://scta.info/property/next")) == nil
			unless @results.dup.filter(:p => RDF::URI("http://scta.info/property/next")) == nil
				#next_item = @data.query(:predicate => RDF::URI.new("http://scta.info/property/next")).first.object.to_s
				next_item = @results.dup.filter(:p => RDF::URI("http://scta.info/property/next")).first[:o].to_s
			else
				next_item = null
			end
			return next_item
		end
		def previous
			#unless @data.query(:predicate => RDF::URI.new("http://scta.info/property/previous")) == nil
			unless @results.dup.filter(:p => RDF::URI("http://scta.info/property/previous")) == nil
				#previous_item = @data.query(:predicate => RDF::URI.new("http://scta.info/property/previous")).first.object.to_s
				previous_item = @results.dup.filter(:p => RDF::URI("http://scta.info/property/previous")).first[:o].to_s
			else
				previous_item = null
			end
			return previous_item
		end

		def order_number
			#ordernumber = @data.query(:predicate => RDF::URI.new("http://scta.info/property/totalOrderNumber")).first.object.to_s.to_i
			ordernumber = @results.dup.filter(:p => RDF::URI("http://scta.info/property/totalOrderNumber")).first[:o].to_s.to_i

		end

		def status
			#status = @data.query(:predicate => RDF::URI.new("http://scta.info/property/status")).first.object.to_s
			status = @results.dup.filter(:p => RDF::URI("http://scta.info/property/status")).first[:o].to_s
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
      		if @confighash[:git_repo] == 'bitbucket.org'
      			fs = @fs.downcase
      		else
      			fs = @fs
      		end
					file_path = "https://#{@confighash[:git_repo]}#{fs}/raw/#{ed}/#{wit}_#{fs}.xml"
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
    
    ## transcription methods

    def transcription?(slug)
    	if slug == 'critical'
    		test_url = RDF::URI.new("http://scta.info/text/#{@commentary_id}/transcription/#{fs}")
    	else
    		test_url = RDF::URI.new("http://scta.info/text/#{@commentary_id}/transcription/#{slug}_#{fs}")
    	end
    	
    	#transcription_array = @data.query(:predicate => RDF::URI.new("http://scta.info/property/hasTranscription"))
    	transcription_array = @results.dup.filter(:p => RDF::URI.new("http://scta.info/property/hasTranscription"))

    	test_array = transcription_array.map {|statement| statement[:o]}
    	return test_array.include? test_url
    	
		end

    def transcription(source: 'local', wit: 'critical', ed: 'master')
    	filehash = self.file_hash(source: source, wit: wit, ed: ed)
    	transcr = Transcription.new(@confighash, filehash)
		end	

		def transcription_slugs(source: 'local', ed: 'master')
			slug_array = []
			#transcriptions = @data.query(:predicate => RDF::URI.new("http://scta.info/property/hasTranscription"))
			transcriptions = @results.dup.filter(:p => RDF::URI.new("http://scta.info/property/hasTranscription"))
			transcriptions.each do |transcription|
				slug_array << transcription[:o].to_s.split("/").last
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