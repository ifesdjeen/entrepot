require 'virtus'

zdef Object.const_missing(name)
  puts "Warning: #{name} was not defined, assuming further definition. Keep calm tho."
  name = Class.new
end

class Article
  include Virtus

  attribute :title,  String
  attribute :text,   String
  attribute :person, Person # If you comment Object.const_missing, Person will (of course) be missing
end


class Person
  include Virtus

  attribute :name,     String
  attribute :gender,   String

  attribute :articles, Array[Article]
end

person = Person.new(:name => "name", :gender => "gender", :articles => [ { :title => "title 1", :text => "text 1" }, { :title => "title 2", :text => "text 2" } ])
article = Article.new(:title => "title 1", :text => "text 1", :person => { :name => "name", :gender => "gender" })

puts person
puts article
