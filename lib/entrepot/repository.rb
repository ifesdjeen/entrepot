require 'active_support/inflector'
require 'active_support/concern'

module Entrepot
  module Repository
    extend ActiveSupport::Concern

    module ClassMethods
      def belongs_to(relation, args)
        @_belongs_to_fields = {}
        @_belongs_to_fields[relation] = args
      end

      def has_many(relation, args)
        @_has_many_fields = {}
        @_has_many_fields[relation] = args
      end

      def belongs_to_fields
        @_belongs_to_fields
      end

      def has_many_fields
        @_has_many_fields
      end

      def data_store
        return @data_store if @data_store
        @data_store = Entrepot::DataStore
      end

      def collection_name
        ActiveSupport::Inflector.tableize(klass_name).gsub("/", "_")
      end

      def klass_name
        name.to_s.gsub("Repository", "")
      end

      def klass
        klass_name.constantize
      end

      protected

      def _instantiate_klass(params={})
        klass.new(params)
      end

    end

    def insert(record)
      collection.insert(self.own_fields(record))
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

    def save
      # if @_has_many_fields.any?

      # end


    end

  end
end
