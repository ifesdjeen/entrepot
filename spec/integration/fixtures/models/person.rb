class Person
  include Virtus
  include Entrepot::Mongo::Model

  attribute :name,     String
  attribute :address,  Address
end
