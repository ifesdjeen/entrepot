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

    def persisted?
      @persisted || false
    end

    def mark_as_persisted
      @persisted = true
    end

    # Ported from Virtus fork
    #
    # Returns a hash of all publicly accessible attributes by
    # recursively calling #to_hash on the objects that respond to it.
    #
    # @example
    #   class Person
    #     include Virtus
    #
    #     attribute :name,    String
    #     attribute :age,     Integer
    #     attribute :email,   String, :accessor => :private
    #
    #     attribute :friend,  Person
    #   end
    #
    #   john = Person.new({ :name => 'John', :age => 28 })
    #   jack = Person.new({ :name => 'Jack', :age => 31, friend => john })
    #
    #   user.to_hash  # => { :name => 'John', :age => 28, :friend => { :name => 'Jack', :age => 31 } }
    #
    # @return [Hash]
    #
    # @api public
    def to_hash
      hash = attributes.dup
      hash.each do |key, value|
        case
        when value.is_a?(Array)
          hash[key] = value.collect do |item_within_value|
            safely_recurse_into(item_within_value) { |i| i.respond_to?(:to_hash) ? i.to_hash : i }
          end
        when value.respond_to?(:to_hash)
          hash[key] = safely_recurse_into(value) do |v| v.to_hash end
        when value.nil?
          hash.delete(key)
        end
      end
      hash
    end

    protected

    # Safely recurses into the value, avoiding StackOverflow errors.
    #
    # Accepts any value parameter, and a block, which will receive this value parameter.
    #
    # @return [Object]
    #
    # @api private
    def safely_recurse_into(value)
      Thread.current[caller.first] ||= []
      caller_stack = Thread.current[caller.first]

      return_value = nil

      if !caller_stack.include?(value.object_id)
        caller_stack.push(self.object_id)
        return_value = yield(value)
        caller_stack.pop
      end

      return_value
    end

  end
end
