require 'spec_helper'
require 'lbp'
require 'rdf'
require 'pry'


describe 'resource object' do
	describe "when resource is input as an RDF::URI" do
		it 'should be able to return short_id of resource' do
			object = Lbp::ResourceIdentifier.new(RDF::URI.new("http://scta.info/resource/sententiae"))
			result = object.short_id
			expect(result).to be == "sententiae"
	 	end
	 	it 'should be able to return resource_url of resource' do
			object = Lbp::ResourceIdentifier.new(RDF::URI.new("http://scta.info/resource/sententiae"))
			result = object.url
			expect(result).to be == "http://scta.info/resource/sententiae"
	 	end
	 	it 'should be able to return RDF::URI object' do
			object = Lbp::ResourceIdentifier.new(RDF::URI.new("http://scta.info/resource/sententiae"))
			result = object.rdf_uri
			expect(result).to be == RDF::URI.new("http://scta.info/resource/sententiae")
	 	end
	 	it 'should return object if the resource is a uri resource (and not a literal)' do
			object = Lbp::ResourceIdentifier.new(RDF::URI.new("http://scta.info/resource/sententiae"))
			result = object.resource
			expect(result).to be_instance_of(Lbp::WorkGroup)
		end
	end
end
