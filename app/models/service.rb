class Service
  include DataMapper::Resource

  attr_accessor :_destroy

  property :id,          Serial
  property :name,        String,  :required => true, :length => 100
  property :description, Text,    :required => false
  property :url,         String,  :required => false,  :length => 250
  
  timestamps :at
  
  belongs_to :map
  property :map_id, Integer
end
