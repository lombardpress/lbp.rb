
require 'nokogiri'
require 'open-uri'

def xslt_transform(xmlfile, xsltfile, xslt_param_array)
	xml  = Nokogiri::XML(open(xmlfile))
	xslt = Nokogiri::XSLT(open(xsltfile))
	result_doc = xslt.transform(xml, xslt_param_array)
	return result_doc
end

				