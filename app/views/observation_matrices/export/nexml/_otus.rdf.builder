


# Nexml.serialize(target: xml, observation_matrix: @observation_matrix, transform: false)
#
xml.instruct!

xml.nex(:nexml,  
'version'            => '0.1',
'generator'          => 'TaxonWorks',                    
'xmlns:xsi'          => 'http://www.w3.org/2001/XMLSchema-instance',
'xmlns:xml'          => 'http://www.w3.org/XML/1998/namespace',
'xmlns:nex'          => 'http://www.nexml.org/2009',        
'xmlns'              => 'http://www.nexml.org/2009',                  
'xsi:schemaLocation' => 'http://www.nexml.org/2009 ../xsd/nexml.xsd',
'xmlns:xsd'          => 'http://www.w3.org/2001/XMLSchema',
'xmlns:dc'           => 'http://purl.org/dc/terms/',
'xmlns:dwc'          => 'http://rs.tdwg.org/dwc/terms/',
'xmlns:xi'           => 'http://www.w3.org/2003/XInclude' # IS THIS NECESSARY?
)  do 

  include_otus(opt) if params[:include_otus]
  include_descriptors(opt) if params[:include_descriptors] 
  # include_trees(opt) if opt[:include_trees]
end # end document
