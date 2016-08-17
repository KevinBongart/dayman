# frozen_string_literal: true
module Dayman
  class Resource
    class << self
      extend Forwardable

      attr_accessor :site

      def_delegators :request,
        :all,
        :filter,
        :find,
        :includes,
        :where

      def path
        name.underscore.pluralize
      end

      private

      def request
        Request.new(self)
      end
    end
  end
end
