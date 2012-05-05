module Entrepot
  module Mongo
    module Model
      extend ActiveSupport::Concern

      include Entrepot::Model

      included do
        attribute :_id,   ::BSON::ObjectId
        attribute :_type, ::String
      end

      def id
        self._id
      end

      def id=(value)
        self._id = value
      end
    end
  end
end
