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
      def update(record, *params)
        params = params[0]
        case record
        when self.klass
          raise Exception if record.id.nil? && params[:query].nil?
          query = params[:query] || {:_id => record.id}

          if params[:atomic_modifiers]
            data_store.update(collection_name, query, params[:atomic_modifiers], params)
            record.attributes = self.find(record.id)
          else
            data_store.update(collection_name, query, record.to_hash, params)
            record.attributes = self.find(record.id)
          end

          record
        else
          raise Exception
        end
      end

      def find(id_or_query)
        case id_or_query
        when Hash
          instantiate_or_raise_not_found_exception(data_store.find(collection_name, id_or_query))
        when BSON::ObjectId
          instantiate_or_raise_not_found_exception(data_store.find_by_id(collection_name, id_or_query))
        when String
          instantiate_or_raise_not_found_exception(data_store.find_by_id(collection_name, BSON::ObjectId(id_or_query)))
        else
          raise Exception
        end
      end

      def raise_not_found_exception?
        true
      end

      def instantiate_or_raise_not_found_exception(found_record)
        case
        when found_record.nil? && raise_not_found_exception?
          raise Exception
        when found_record.nil? && !raise_not_found_exception?
          nil
        when found_record.is_a?(::Mongo::Cursor)
          found_record.collect do |i| instantiate_or_raise_not_found_exception(i) end
        else
          klass.new(found_record)
        end
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
