require 'mongo'
require 'virtus'

require 'active_support/concern'

class Article
  include Virtus

  attribute :title,  String
  attribute :text,   String
  attribute :person_id, BSON::ObjectId
  attribute :person, 'Person'
end


class Address
  include Virtus

  attribute :street,  String
  attribute :city,    String
  attribute :country, String
end

class Person
  include Virtus

  attribute :name,     String
  attribute :gender,   String

  attribute :articles, Array[Article]
  attribute :address, Address


  def recursive_to_hash
    hash = self.to_hash
    hash.each do |key, value|
      if value.respond_to?(:to_hash)
        hash[key] = value.to_hash
      end
    end
  end
end


person = Person.new(:name => "name", :gender => "gender", :articles => [ { :title => "title 1", :text => "text 1" }, { :title => "title 2", :text => "text 2" } ], :address => { :street => "street", :city => "city", :country => "country" } )

puts person
