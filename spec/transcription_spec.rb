require 'spec_helper'
require 'lbp'
require 'pry'
require 'nokogiri'

describe 'transcript object' do
	$transcript_obj1 = Lbp::Resource.find("http://scta.info/resource/wdr-l1d1/wettf15/transcription")
	$transcript_obj2 = Lbp::Resource.find("http://scta.info/resource/principiumIV/critical/transcription")

	it 'returns type of resource' do
		result = $transcript_obj1.type.short_id
		expect(result).to be == "transcription"
 	end
 	it 'returns transcription type of transcription (documentary)' do
		result = $transcript_obj1.transcription_type
		expect(result).to be == "documentary" # the use of documentary could be confusing because somtimes I say diplomatic
 	end
 	it 'returns transcription type of transcription (critical)' do
		result = $transcript_obj2.transcription_type
		expect(result).to be == "critical"
 	end
 	it 'returns file path for transcription' do
		result = $transcript_obj1.file_path
		expect(result).to be_kind_of(String)
 	end
 	it 'returns file path for transcription' do
		result = $transcript_obj1.doc_path("develop")

		expect(result).to be_kind_of(String)
 	end
 	it 'returns file path for transcription' do
		result = $transcript_obj2.file_path
		expect(result).to be_kind_of(String)
 	end
end
