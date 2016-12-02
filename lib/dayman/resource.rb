# frozen_string_literal: true
module Dayman
  class Resource
    attr_accessor :id, :attributes, :relationships

    class << self
      extend Forwardable

      attr_accessor :site

      def_delegators :request,
        :all,
        :fields,
        :filter,
        :find,
        :includes,
        :select,
        :sort,
        :where

      def path
        name.demodulize.underscore.pluralize
      end

      def has_one(relationship_name)
        attr_accessor relationship_name
      end

      def has_many(relationship_name)
        instance_variable_name = "@#{relationship_name}".to_sym

        define_method(relationship_name) do
          if instance_variable_defined?(instance_variable_name)
            instance_variable_get(instance_variable_name)
          else
            instance_variable_set(instance_variable_name, [])
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
    end

    def method_missing(name, *args, &block)
      attributes.key?(name) ? attributes[name] : super
    end

    def respond_to_missing?(name, include_private = false)
      attributes.key?(name) || super
    end
  end
end
