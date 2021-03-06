# Entrepôt, for people who treat their data with care.
[![Build Status](https://secure.travis-ci.org/ifesdjeen/entrepot.png?branch=master)](http://travis-ci.org/ifesdjeen/entrepot)

Back in Java days, everything was easy: you define a Plain Old Java Object (POJO), fill it up with some data, afterwards you let others fill it up with data.
Filling up with data is strictly a Repository problem, whilst validation and internal conversions are more related to the object itself. Trying to tie
absolutely different data stores into a single interface is a tedious task. Untangle your thoughts and use the idioms that come from your db's world.

That particular project and it's satellite is an attempt to bring at least two data stores together using Virtus.

Gain a full control over your databases and objects, again. Don't let them tie your arms.

Entrepot woks with hashes, but that was made mostly for flexibility and ease of ad-hoc usage.

Entrepot is similar to [Curator](https://github.com/braintree/curator) in many ways

# What Entrepôt can do so far

Let's make a very basic setup first. Person, that has an address as an embedded Address record and referenced Article records.

```ruby
class Address
  include Virtus
  include Entrepot::Model

  attribute :street,  String
  attribute :city,    String
  attribute :country, String
end

class Person
  include Virtus
  include Entrepot::Mongo::Model

  attribute :name,     String
  attribute :address,  Address
end

class PersonRepository
  include Entrepot::Repository

  has_many :articles, :repository => :ArticleRepository
end
```
## Inserting documents

You can insert a hash:

```ruby
PersonRepository.insert({:name => "John Lennon", :address => { :street => "Dachstr 15", :city => "Dresden", :country => "Deutschland" } })
```

Or an object, that responds to #to_hash:

```ruby
person = Person.new({:name => "John Lennon", :address => { :street => "Dachstr 15", :city => "Dresden", :country => "Deutschland" } })
PersonRepository.insert(person)
person.id # will return you an ObjectId of newly inserted record
```

## Finding documents

Again, little set-up:

```ruby
person = Person.new({:name => "John Lennon", :address => { :street => "Dachstr 15", :city => "Dresden", :country => "Deutschland" } })
PersonRepository.insert(person)
```

Find by ID:

```ruby
PersonRepository.find(person.id)
# returns #<Person:0x007face469a7b0 @name="John Lennon" @address= ...>
```

Or by query:

```ruby
PersonRepository.find({:name => /^John/})
# returns #<Person:0x007face469a7b0 @name="John Lennon" @address= ...>
```

## Updating documents

By replacing an existing record in Database:

```ruby
person.name = "New Groove"
PersonRepository.update(object)
# returns #<Person:0x007face469a7b0 @name="New Groove" @address= ...>
```

Or using Atomic Modifiers:

```ruby
PersonRepository.update(person, :atomic_modifiers => { "$set" => { :name => "New Groove" } })
# returns #<Person:0x007face469a7b0 @name="New Groove" @address= ...>
```

Additionally, you can specify which record you want to replace or update:

```ruby
PersonRepository.update(person, :query => { :name => /^John/ })
# returns #<Person:0x007face469a7b0 @name="New Groove" @address= ...>
```

## Removing documents

You can remove by the record:

```ruby
PersonRepository.remove(person)
```

Or by id:

```ruby
PersonRepository.remove(person.id)
```

Or by any query:

```ruby
PersonRepository.remove({:name => /^John/})
```

## STI

We also support STI, pretty much the same way you are used to use it in ActiveRecord-like ORMs.

```ruby
class Manager < Person
end

manager = Manager.new({:name => "Mr. Manager", :address => { :street => "Managerstr 11", :city => "Dresden", :country => "Deutschland" } })

PersonRepository.insert(manager)
manager._type # => "Manager"
PersonRepository.find(manager.id).class # => Manager
```

# Disclaimer

You may feel or may not feel the same problem. If you have a form with an ability to manipulate nested embedded fields without headache, validate in a way that
is absolutely not related to persisting, you have found a friend.

This is a highly experimental repository. It is highly discouraged to even consider using that code in production. It's quite clear that it will take many iterations
until even the API stabilizes.

# Current Problems

So far it became very clear that every data-store has a unique set of features, and right now it's quite difficult to say wether it's a good idea to hide functionality,
or develop custom wrappers for each data-store that will encourage people to use more features. Until now, our major problem, which led us to development of that
lib, was that ActiveRecord-like drivers sometimes hide datastore functionality. Two examples that come to my mind are bulk updates / inserts, atomic operators (more Mongo
related) and eager loading. Latter is sometimes supported but leads to a gazillion unnecessary database calls.

## License

Copyright (C) 2011-2012 Alex Petrov

Distributed under the Ruby License.

