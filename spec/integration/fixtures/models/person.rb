require 'mongo'

class Person
  include Virtus
  include Entrepot::Model

  attribute :id,       ObjectId
  attribute :name,     String
  attribute :address, Address
end
