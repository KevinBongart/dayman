# frozen_string_literal: true

require_relative 'request/fields'
require_relative 'request/filters'
require_relative 'request/includes'
require_relative 'request/pagination'
require_relative 'request/sorting'

module Dayman
  class Request
    include Fields
    include Filters
    include Includes
    include Pagination
    include Sorting

    attr_reader :resource,
      :fieldsets,
      :filters,
      :included_resources,
      :page_size,
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
      response_body = fetch_response(resource.path, query_parameters).body
      Parsers::CollectionParser.new(resource: resource, response: response_body).parse
    end

    # http://jsonapi.org/format/#fetching-resources
    def find(id)
      response_body = fetch_response([resource.path, id].join('/')).body
      Parsers::MemberParser.new(resource: resource, response: response_body).parse
    end

    def first
      limit(1)

      all.first
    end

    private

    def connection
      Faraday.new(url: resource::API_BASE_URL)
    end

    def query_parameters
      params = {}

      params.merge!(filters_to_query_parameters)
      params.merge!(included_resources_to_query_parameters)
      params.merge!(fieldsets_to_query_parameters)
      params.merge!(sort_fields_to_query_parameters)
      params.merge!(pagination_to_query_parameters)
    end

    def fetch_response(path, params = {})
      response = connection.get(path, params)

      unless response.status.in?(200..399)
        raise "Error #{response.status}: #{response.reason_phrase}"
      end

      response
    end
  end
end
