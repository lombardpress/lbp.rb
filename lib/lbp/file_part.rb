require 'nokogiri'
#require 'rugged'
#require 'lbp/functions'
require 'lbp'

module Lbp
	class FilePart
		attr_reader :partid, :element
		def initialize(filepath, transcription_type, confighash, partid)
			
			@confighash = confighash
			
			@partid = partid
			@filepath = filepath
			@transcription_type = transcription_type
			@element = self.element_name
			
	  end

	  def element_name
	  	transcr = File.new(@filepath, @transcription_type, @confighash)
	  	xmlobject = transcr.nokogiri
	  	element_name = xmlobject.xpath("name(//node()[@xml:id='#{@partid}'])", 'tei' => 'http://www.tei-c.org/ns/1.0')
	  end

	  # def number
	  # 	transcr = File.new(@filepath, @transcription_type, @confighash)
	  # 	totalparts = transcr.number_of_body_paragraphs
	  # 	xmlobject = transcr.nokogiri
	  # 	parts_following = xmlobject.xpath("//tei:body//tei:#{@element}[preceding::tei:#{@element}[@xml:id='#{@partid}']]", 'tei' => 'http://www.tei-c.org/ns/1.0').count
	  # 	part_number = totalparts - parts_following

	  	
			# return part_number
	  # end
	  def next
	  	xmlobject = File.new(@filepath, @transcription_type, @confighash).nokogiri
	  	nextpartid = xmlobject.xpath("//tei:#{@element}[@xml:id='#{@partid}']/following::tei:#{@element}[1]/@xml:id", 'tei' => 'http://www.tei-c.org/ns/1.0')
			if nextpartid.text == nil
        return nil
      else
				return FilePart.new(@filepath, @transcription_type, @confighash, nextpartid.text)
      end	
	  end
	  def previous
	  	xmlobject = File.new(@filepath, @transcription_type, @confighash).nokogiri
	  	previouspartid = xmlobject.xpath("//tei:#{@element}[@xml:id='#{@partid}']/preceding::tei:#{@element}[1]/@xml:id", 'tei' => 'http://www.tei-c.org/ns/1.0')
	  	if previouspartid.empty?
        return nil
      else
				return FilePart.new(@filepath, @transcription_type, @confighash, previouspartid.text)
      end
	  end
		def number_of_zones
			xmlobject = File.new(@filepath, @transcription_type, @confighash).nokogiri
			partid_with_hash = "#" + @partid
			result = xmlobject.xpath("/tei:TEI/tei:facsimile//tei:surface/tei:zone[@start='#{partid_with_hash}']", 'tei' => 'http://www.tei-c.org/ns/1.0')
			return result.count
		end

	  def xml
	  	result = File.new(@filepath, @transcription_type, @confighash).nokogiri
	  	p = result.xpath("//tei:#{@element}[@xml:id='#{@partid}']", 'tei' => 'http://www.tei-c.org/ns/1.0')
	  end

	  def transform(xsltfile, xslt_param_array=[])
	  	result = File.new(@filepath, @transcription_type, @confighash).transform(xsltfile, xslt_param_array)
			p = result.xpath("//#{@element}[@id='#{@partid}']")
			return p
		end
		def transform_plain_text(xslt_param_array=[])
			# not that it could be slightly confusing that paragraph plain text uses the transform clean,
			# because we still the basic paragraph elements in order to select the desired paragraph
			result = File.new(@filepath, @transcription_type, @confighash).transform_clean_nokogiri(xslt_param_array)
			
			p = result.xpath("//#{@element}[@id='#{@partid}']")
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