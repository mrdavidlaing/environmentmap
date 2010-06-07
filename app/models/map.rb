require 'rexml/document'

class Map
  include DataMapper::Resource

  property :id,   Serial
  property :name, String,      :required => true, :length => 100
  property :svgdata, Text,     :required => false
  property :width, Integer,    :required => false
  property :height, Integer,    :required => false

  timestamps :at
  
  has n, :services

  def svgdata_as_clickable
    doc = REXML::Document.new(self.svgdata)
    doc.elements.each("//[starts-with(@id,'service')]") do |clickable_element|
      service_id_parts = clickable_element.attributes["id"].split('_')
      unless service_id_parts.length < 2
        clickable_element.attributes["onclick"] = "top.window.show_detail("+service_id_parts[1]+")"
      end
    end
    doc
  end

end
