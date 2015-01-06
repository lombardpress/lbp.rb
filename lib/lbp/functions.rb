
require 'nokogiri'

def xslt_transform(xmlfile, xsltfile, xslt_param_array)
	xml  = Nokogiri::XML(File.read(xmlfile))
	xslt = Nokogiri::XSLT(File.read(xsltfile))
	result_doc = xslt.transform(xml, xslt_param_array)
	return result_doc
end				