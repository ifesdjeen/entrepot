require 'active_support/inflector'
require 'active_support/concern'

module Entrepot
  module Repository
    extend ActiveSupport::Concern


    module ClassMethods

      #
      # Relationshops
      #

      def belongs_to(relation, *args)
        @_belongs_to_fields = {}
        @_belongs_to_fields[relation] = args
      end

      def has_many(relation, *args)
        @_has_many_fields = {}
        @_has_many_fields[relation] = args
      end

      def has_one(relation, *args)
        @_has_one_fields = {}
        @_has_one_fields[relation] = args
      end

      def data_store
        return @data_store if @data_store
        @data_store = Entrepot.data_store
      end

      def collection_name
        @collection_name if @collection_name
        @collection_name = ActiveSupport::Inflector.tableize(record_class_name).gsub("/", "_")
      end

      def record_class
        record_class_name.constantize
      end

      def count(params = {})
        data_store.count(collection_name, params)
      end

      #
      # Repository Operations
      #

      def insert(record, params = {})
        case record
        when Hash
          self.insert(record_class.new(record), params)
        when self.record_class
          record.id = data_store.insert(collection_name, record.to_hash, params)
          record.mark_as_persisted
          record
        else
          raise Exception
        end
      end

      def extract_query(record, params)
        params[:query] || {:_id => record.id}
      end

      def remove(record_id_or_query, params = {})
        params = params[0] || {}

        case record_id_or_query
        when BSON::ObjectId
          remove({:_id => record_id_or_query}, params)
        when String
          remove(BSON::ObjectId(record_id_or_query), params)
        when self.record_class
          remove(record_id_or_query.id, params)
        when Hash
          data_store.remove(collection_name, record_id_or_query, params)
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
        params = params[0] || {}
        if record.is_a?(self.record_class)
          raise Exception if record.id.nil? && params[:query].nil?
          query = extract_query(record, params)

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

      def update_bulk(records, params = {})
      end

      protected

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
          record_class.new(found_record)
        end
      end

      def record_class_name
        name.to_s.gsub("Repository", "")
      end

      def _instantiate_record_class(params={})
        record_class.new(params)
      end

      def belongs_to_fields
        @_belongs_to_fields
      end

      def has_many_fields
        @_has_many_fields
      end
    end

    def own_fields(record)
      record.recursive_to_hash.select do |key, value| !self.class.has_many_fields.keys.include?(key) end
    end

    def foreign_fields
      @_belongs_to_fields + @_has_many_fields
    end

    included do
      extend Entrepot::Repository::ClassMethods
    end

  end
end
