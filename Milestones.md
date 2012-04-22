# Here are several milestones we're trying to achieve now (the list may grow or shrink as we start understanding things better):

1. Create a basic Mongodb repository on top of Virtus, that should be able to perform the basic entity operations (CRUD), indexing and open access to atomic modifiers.
2. Add relationships to Repository:
   - one-to-one, both embedded and referenced
   - one-to-many, both embedded and referenced
   - many-to-many
3. Add Strategies for preloading, persisting to simplify most of use-cases for persisting and fetching items, such as:
   - eagerly load children
   - eagerly load children for the array of entities
   - batch-insert children

