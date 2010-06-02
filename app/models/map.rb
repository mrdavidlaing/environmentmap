class Map
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String,      :required => true, :length => 500
  property :svgdata, Text,     :required => false 
  timestamps :at 
end
