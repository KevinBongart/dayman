# frozen_string_literal: true

require 'dayman/request/fields'
require 'dayman/request/filters'
require 'dayman/request/includes'
require 'dayman/request/sorting'

module Dayman
  class Request
    include Fields
    include Filters
    include Includes
    include Sorting

    attr_reader :resource,
      :fieldsets,
      :filters,
      :included_resources,
      :sort_fields

    def initialize(resource)
      @resource = resource

      @fieldsets = {}
      @filters = {}
      @included_resources = []
      @sort_fields = []
    end

    # http://jsonapi.org/format/#fetching-resources
    def all
      response = connection.get(resource.path, query_parameters)
      Parsers::CollectionParser.new(resource: resource, response: response.body).parse
    end

    # http://jsonapi.org/format/#fetching-resources
    def find(id)
      response = connection.get([resource.path, id].join('/'))
      Parsers::MemberParser.new(resource: resource, response: response.body).parse
    end

    private

    def connection
      Faraday.new(url: resource.site)
    end

    def query_parameters
      params = {}

      params.merge!(filters_to_query_parameters)
      params.merge!(included_resources_to_query_parameters)
      params.merge!(fieldsets_to_query_parameters)
      params.merge!(sort_fields_to_query_parameters)
    end
  end
end
