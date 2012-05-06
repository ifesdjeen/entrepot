class Address
  include Entrepot::Mongo::Model

  attribute :street,  String
  attribute :city,    String
  attribute :country, String
end
