class Address
  include Virtus
  include Entrepot::Model

  attribute :street,  String
  attribute :city,    String
  attribute :country, String
end
