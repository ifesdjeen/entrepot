class Article
  include Entrepot::Mongo::Model

  attribute :title,  String
  attribute :text,   String
  attribute :person_id, BSON::ObjectId
  attribute :person, Person
end
