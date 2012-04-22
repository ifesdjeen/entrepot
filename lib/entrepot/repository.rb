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
        @data_store = Entrepot.data_store
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
          self.insert(klass.new(record), params)
        when self.klass
          record.id = data_store.insert(collection_name, record.to_hash, params)
          record.mark_as_persisted
          record
        else
          raise Exception
        end
      end

      #
      # Possible params:
      #  @query - query for the update operation, if record is found not by an ID
      #  @atomic_modifiers - modifiers, which will take precedence to record values
      #
      def update(record, params = {})
      end

      def update_bulk(records, params = {})
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
