class Person
  include Entrepot::Mongo::Model

  attribute :name,     String
  attribute :address,  Address
end

class Manager < Person
end
