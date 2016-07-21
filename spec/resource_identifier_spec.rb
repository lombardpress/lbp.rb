require 'spec_helper'
require 'lbp'
require 'rdf'
require 'pry'


describe 'resource object' do 

	describe "when resource is a RDF::URI" do
		it 'should return short_id of resource' do 
			object = Lbp::ResourceIdentifier.new(RDF::URI.new("http://scta.info/resource/sententia"))
			result = object.short_id
			expect(result).to be == "sententia"
	 	end
	 	it 'should return resource_url of resource' do 
			object = Lbp::ResourceIdentifier.new(RDF::URI.new("http://scta.info/resource/sententia"))
			result = object.url
			expect(result).to be == "http://scta.info/resource/sententia"
	 	end
	 	it 'should return resource_rdf_uri of resource created from short id' do 
			object = Lbp::ResourceIdentifier.new(Lbp::ResourceIdentifier.from_short("sententia"))
			result = object.rdf_uri
			expect(result).to be == RDF::URI.new("http://scta.info/resource/sententia")
	 	end
	 	it 'should return object if the resource is a uri resource (and not a literal)' do 
			object = Lbp::ResourceIdentifier.new("lectio1")
			result = object.resource
			expect(result).to be_instance_of(Lbp::Expression)
		end
	end
	describe "when resource is a RDF::Literal" do
		it 'should return short_id of resource' do 
			object = Lbp::ResourceIdentifier.new(RDF::Literal.new("Test"))
			result = object.short_id
			expect(result).to be == "Test"
	 	end
	 	it 'should return resource_url of resource' do 
			object = Lbp::ResourceIdentifier.new(RDF::Literal.new("Test"))
			result = object.url
			expect(result).to be == "Test"
	 	end
	 	it 'should return resource_rdf_uri of resource created from short id' do 
			object = Lbp::ResourceIdentifier.new(RDF::Literal.new("Test"))
			result = object.rdf_uri #this method name is a little bit misleading
			expect(result).to be == RDF::Literal.new("Test")
	 	end
	 	it 'should return object if the resource is a uri resource (and not a literal)' do 
			object = Lbp::ResourceIdentifier.new(RDF::Literal.new("Test"))
			result = object.resource
			expect(result).to be == nil
		end
	end	
end