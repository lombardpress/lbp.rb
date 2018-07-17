require 'spec_helper'
require 'lbp'
require 'rdf'
require 'pry'


describe 'workGroup object' do
	it 'should return description of workGroup' do
		resource = Lbp::WorkGroup.find("http://scta.info/resource/scta")
		result = resource.description
		expect(result).to be_instance_of(String)
 	end
 	it 'should list of available workGroups as an array' do
		resource = Lbp::WorkGroup.find("http://scta.info/resource/scta")
		result = resource.work_groups
		expect(result).to be_instance_of(Array)
 	end
 	it 'should list of available expressions as array' do
		resource = Lbp::WorkGroup.find("http://scta.info/resource/sententiae")
		result = resource.expressions
		expect(result).to be_instance_of(Array)
 	end
 	it 'should list of available expressions as array' do
		resource = Lbp::WorkGroup.find("http://scta.info/resource/scta")
		result = resource.expressions
		expect(result).to be_instance_of(Array)
 	end
end
