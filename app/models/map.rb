class Map
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String,        :required => true, :length => 500
  timestamps :at 
end
