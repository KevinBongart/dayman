# frozen_string_literal: true
module Dayman
  class Resource
    include ActiveModel::Model

    attr_accessor :id, :attributes

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
        name.underscore.pluralize
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
