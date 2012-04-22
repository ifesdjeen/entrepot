module Entrepot
  module Mongo
    class DataStore < Entrepot::DataStore
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

      def count(collection_name, params = {})
        collection(collection_name).count(params)
      end

      def insert(collection_name, record, params = {})
        collection(collection_name).insert(params)
      end

      def find_by_id(collection_name, id)
        collection(collection_name).find(BSON::ObjectId(id))
      end

      def drop(collection_name, id)
        collection.drop
      end

      def reset!
        db.collections.each { |c| c.drop unless c.name =~ /system/ }
      end
    end
  end
end
