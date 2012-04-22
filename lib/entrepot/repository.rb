require 'active_support/inflector'
require 'active_support/concern'

module Entrepot
  module Repository
    extend ActiveSupport::Concern


    module ClassMethods

      #
      # Represents belongs_to relationship
      #
      def belongs_to(relation, args)
        @_belongs_to_fields = {}
        @_belongs_to_fields[relation] = args
      end

      #
      # Represents has_many relationship
      #

      def has_many(relation, args)
        @_has_many_fields = {}
        @_has_many_fields[relation] = args
      end

      def data_store
        return @data_store if @data_store
        @data_store = Entrepot::DataStore.new
      end

      def collection_name
        @collection_name if @collection_name
        @collection_name = ActiveSupport::Inflector.tableize(klass_name).gsub("/", "_")
      end

      def klass
        klass_name.constantize
      end

      def count(params = {})
        data_store.count(collection_name, params)
      end

      def insert(record, params = {})
        case record
        when Hash
          data_store.insert(collection_name, record, params)
        when self.klass
          data_store.insert(collection_name, record.to_hash, params)
        else
          raise Exception
        end
      end

      protected

      def klass_name
        name.to_s.gsub("Repository", "")
      end

      def _instantiate_klass(params={})
        klass.new(params)
      end

      def belongs_to_fields
        @_belongs_to_fields
      end

      def has_many_fields
        @_has_many_fields
      end
    end


    def find_one(attributes = {})
      collection.find_one(attributes)
    end


    def own_fields(record)
      record.recursive_to_hash.select do |key, value| !self.class.has_many_fields.keys.include?(key) end
    end

    included do
      extend Entrepot::Repository::ClassMethods
    end


  end
end
