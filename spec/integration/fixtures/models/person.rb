class Person
  include Virtus
  include Entrepot::Model

  attribute :name,     String
  attribute :gender,   String

  attribute :articles, Array[Article]
  attribute :address, Address

end
