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
        collection(collection_name).insert(record)
      end

      def update(collection_name, query, record_or_modifiers, params = {})
        collection(collection_name).update(query, record_or_modifiers)
      end

      def find_one(collection_name, query)
        collection(collection_name).find_one(query)
      end

      def find_by_id(collection_name, id)
        collection(collection_name).find_one(id)
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
