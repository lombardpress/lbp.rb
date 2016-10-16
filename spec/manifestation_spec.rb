require 'spec_helper'
require 'lbp'
require 'rdf'
require 'pry'


describe 'manifestation object' do
	it 'should return array of transcriptions for this manifestaiton' do
		result = Lbp::Resource.find("http://scta.info/resource/lectio1/reims").transcriptions
		expect(result).to be_instance_of(Array)
 	end
 	it 'should return canonical transcription for this manifestaiton' do
		result = Lbp::Resource.find("http://scta.info/resource/lectio1/reims").canonical_transcription.to_s
		expect(result).to be == "http://scta.info/resource/lectio1/reims/transcription"
 	end
end
