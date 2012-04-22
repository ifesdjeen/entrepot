require 'mongo'

module Entrepot
  class DataStore
    def connection
      return @connection if @connection
      @connection = ::Mongo::Connection.new
    end

    def db
      return @db if @db
      @db = self.connection['entrepot-test']
    end

    def collection(collection_name)
       self.db[collection_name]
    end

    def find_by_id(collection_name, id)
      collection.find(BSON::ObjectId(id))
    end

    def drop(collection_name, id)
      collection.drop
    end


    protected

    def reset!
      db.collections.each { |c| c.drop unless c.name =~ /system/ }
    end

  end
end
