module Entrepot
  module Mongo
    module Model

      def self.included(base)
        base.send(:include, ::Virtus)
        base.extend(::Entrepot::Model::ClassMethods)
        base.send(:include, ::Entrepot::Model)

        base.attribute :_id,   ::BSON::ObjectId
        base.attribute :_type, ::String
      end

      private_class_method :included

      def id
        self._id
      end

      def id=(value)
        self._id = value
      end
    end
  end
end
