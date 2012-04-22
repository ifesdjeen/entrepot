class Article
  include Virtus
  include Entrepot::Model

  attribute :title,  String
  attribute :text,   String
  attribute :person_id, BSON::ObjectId
  attribute :person, Person
end
