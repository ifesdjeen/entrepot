# Entrepôt, for people who treat their data with care.

Back in Java days, everything was easy: you define a Plain Old Java Object (POJO), fill it up with some data, afterwards you let others fill it up with data.
Filling up with data is strictly a Repository problem, whilst validation and internal conversions are more related to the object itself. Trying to tie
absolutely different data stores into a single interface is a tedious task. Untangle your thoughts and use the idioms that come from your db's world.

That particular project and it's satellite is an attempt to bring at least two data stores together using Veritas.

Gain a full control over your databases and objects, again. Don't let tie your arms.

Entrepot is similar to "Curator":(https://github.com/braintree/curator) in many ways

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

