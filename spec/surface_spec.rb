require 'spec_helper'
require 'lbp'
require 'rdf'
require 'pry'


describe 'surface object' do
	it 'should return next surface' do
		surface = Lbp::Resource.find("http://scta.info/resource/sorb/2r")
		next_surface = surface.next
		expect(next_surface).to be_instance_of(Lbp::ResourceIdentifier)
 	end
	it 'should return nil for previous surface when no prev surface exists' do
		surface = Lbp::Resource.find("http://scta.info/resource/sorb/2r")
		previous_surface = surface.previous
		expect(previous_surface).to be == nil
 	end
end
