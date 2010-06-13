# TODO: delete related services when map deleted

require 'rexml/document'
require "dm-accepts_nested_attributes"

class Map
  include DataMapper::Resource

  property :id,   Serial
  property :name, String,      :required => true, :length => 100
  property :svgdata, Text,     :required => false
  property :width, Integer,    :required => false
  property :height, Integer,    :required => false

  timestamps :at
  
  has n, :services
  accepts_nested_attributes_for :services, :reject_if => lambda { |a| a[:name].blank? }

  def svgdata_as_clickable
    javascript_fn = REXML::Document.new(<<EOF
<script type="text/ecmascript"><![CDATA[

    var SVGDocument = null;
    var SVGRoot = null;

    function Init(evt)
    {
       SVGDocument = evt.target.ownerDocument;
       SVGRoot = SVGDocument.documentElement;
       SVGRoot.currentScale = 0.5;
    };

    function show_details(service_id)
    {
       top.window.show_detail(service_id);
    }

 ]]></script>
EOF
)
    doc = REXML::Document.new(self.svgdata)

    doc.elements['svg'].attributes['onload'] = "Init(evt)"
    doc.root.add(javascript_fn)

    doc.elements.each("//[starts-with(@id,'service')]") do |clickable_element|
      service_id_parts = clickable_element.attributes["id"].split('_')
      unless service_id_parts.length < 2
        clickable_element.attributes["onclick"] = "top.window.show_detail("+service_id_parts[1]+")"
        clickable_element.attributes["cursor"] = "pointer"
      end
    end
    doc
  end

end
