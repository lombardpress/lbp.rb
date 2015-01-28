
require 'nokogiri'
require 'open-uri'

def xslt_transform(xml_open_uri_file, xsltfile, xslt_param_array)
	xml  = xml_open_uri_file
	xslt = Nokogiri::XSLT(open(xsltfile))
	result_doc = xslt.transform(xml, xslt_param_array)
	return result_doc
end

def xslt_apply_to(xml_open_uri_file, xsltfile, xslt_param_array)
	xml  = xml_open_uri_file
	xslt = Nokogiri::XSLT(open(xsltfile))
	result_doc = xslt.apply_to(xml, xslt_param_array)
	return result_doc
end



				