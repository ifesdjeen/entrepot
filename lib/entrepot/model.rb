require 'active_support/concern'

module Entrepot

  #
  # This module should not exist, in essence.
  # As of moment of writing (April 2012), Virtus does not support circular dependencies for
  # models, neither it supports an ability to lazily define or define a dependency via
  # string or symbol. So either you pre-define a class (you remember good old C days, right?
  # or I open up a class and give you a waring which you shouldn't be scared of.
  #
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      def const_missing(name)
        puts "Warning: #{name} was not defined, assuming further definition. Keep calm tho."
        name = Class.new
      end
    end

    included do
      extend Entrepot::Model::ClassMethods
    end

    def recursive_to_hash
      hash = self.to_hash
      hash.each do |key, value|
        if value.respond_to?(:to_hash)
          hash[key] = value.to_hash
        end
      end
    end
  end
end
