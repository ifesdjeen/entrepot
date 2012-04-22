class Person
  include Virtus
  include Entrepot::Model

  attribute :name,     String
  attribute :address, Address
end
