# frozen_string_literal: true
module Dayman
  class Resource
    attr_accessor :id, :attributes, :relationships

    class << self
      extend Forwardable

      def_delegators :request,
        :all,
        :fields,
        :filter,
        :find,
        :first,
        :includes,
        :select,
        :sort,
        :where

      def path
        name.demodulize.underscore.pluralize
      end

      def has_one(relationship_name)
        define_method(relationship_name) do
          relationships.fetch(relationship_name)
        end

        define_method("#{relationship_name}=") do |value|
          relationships[relationship_name] = value
        end
      end

      def has_many(relationship_name)
        define_method(relationship_name) do
          relationships.fetch(relationship_name) do
            relationships[relationship_name] = []
          end
        end
      end

      private

      def request
        Request.new(self)
      end
    end

    def initialize(id: nil, attributes: {})
      @id = id
      @attributes = attributes
      @relationships = {}
    end

    def method_missing(name, *args, &block)
      if attributes.key?(name)
        attributes[name]
      elsif relationships.key?(name)
        relationships[name]
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      attributes.key?(name) || relationships.key?(name) || super
    end
  end
end
