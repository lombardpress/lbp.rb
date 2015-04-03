require 'nokogiri'
#require 'rugged'
require 'lbp/functions'

module Lbp
	class Paragraph
		attr_reader :pid 
		def initialize(confighash, filehash, pid)
			
			@confighash = confighash
			@filehash = filehash
			@pid = pid
			
	  end

	  def number
	  	transcr = Transcription.new(@confighash, @filehash)
	  	totalparagraphs = transcr.number_of_body_paragraphs
	  	xmlobject = transcr.nokogiri
	  	paragraphs_following = xmlobject.xpath("//tei:body//tei:p[preceding::tei:p[@xml:id='#{@pid}']]", 'tei' => 'http://www.tei-c.org/ns/1.0').count
	  	paragraph_number = totalparagraphs - paragraphs_following
	  	
			return paragraph_number
	  end
	  def next
	  	xmlobject = Transcription.new(@confighash, @filehash).nokogiri
	  	nextpid = xmlobject.xpath("//tei:p[@xml:id='#{@pid}']/following::tei:p[1]/@xml:id", 'tei' => 'http://www.tei-c.org/ns/1.0')
			if nextpid.text == nil
        return nil
      else
				return Paragraph.new(@confighahs, @filehash, nextpid.text)
      end
	  end
	  def previous
	  	xmlobject = Transcription.new(@confighash, @filehash).nokogiri
	  	previouspid = xmlobject.xpath("//tei:p[@xml:id='#{@pid}']/preceding::tei:p[1]/@xml:id", 'tei' => 'http://www.tei-c.org/ns/1.0')
	  	if previouspid.empty?
        return nil
      else
				return Paragraph.new(@confighash, @filehash, previouspid.text)
      end
	  end
	  def xml
	  	result = Transcription.new(@confighash, @filehash).nokogiri
	  	p = result.xpath("//tei:p[@xml:id='#{@pid}']", 'tei' => 'http://www.tei-c.org/ns/1.0')
	  end

	  def transform(xsltfile, xslt_param_array=[])
	  	result = Transcription.new(@confighash, @filehash).transform(xsltfile, xslt_param_array)
			p = result.xpath("//p[@id='#{@pid}']")
			return p
		end
		def transform_plain_text(xslt_param_array=[])
			# not that it could be slightly confusing that paragraph plain text uses the transform clean,
			# because we still the basic paragraph elements in order to select the desired paragraph
			result = Transcription.new(@confighash, @filehash).transform_clean_nokogiri(xslt_param_array)
			
			p = result.xpath("//p[@id='#{@pid}']")
			return p
		end

		def word_count
    	plaintext = self.transform_plain_text
    	size = plaintext.text.split.size
    end
    def word_array
    	plaintext = self.transform_plain_text
    	word_array = plaintext.text.split
    	word_array.map!{ |word| word.downcase}
    end
    def word_frequency(sort='frequency', order='descending')
    	word_array = self.word_array
    	wf = Hash.new(0)
			word_array.each { |word| wf[word] += 1 }
			
			if sort == "frequency" 
				if order == "descending" # high to low
					wf = wf.sort_by{|k,v| v}.reverse
				elsif order == "ascending" # low to high
					wf = wf.sort_by{|k,v| v}
				end
			elsif sort == "word"
				if order == "descending" # z - a
						wf = wf.sort_by{|k,v| k}.reverse
				elsif order == "ascending" #a - z
						wf = wf.sort_by{|k,v| k}
				end
			end
			return wf.to_h
		end
	end
end