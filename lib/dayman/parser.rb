# frozen_string_literal: true

module Dayman
  class Parser
    def initialize(resource:, response:)
      @resource = resource
      @raw_response = response
    end

    def collection
      return [] if parsed_response.blank?

      parsed_response[:data].map do |item|
        response_item_to_object(item).tap do |resource|
          item[:relationships]&.each do |relationship_name, relationship_content|
            next unless resource.respond_to?(relationship_name)

            if relationship_content.is_a?(Array)
              relationship_content.each do |bla|
                bla[:data]
              end
            else
              included_item = parsed_response[:included].find do |e|
                e.slice(:id, :type) == relationship_content[:data].slice(:id, :type)
              end

              resource.send("#{relationship_name}=", response_item_to_object(included_item))
            end
          end
        end
      end
    end

    def member
      return if parsed_response.blank?

      response_item_to_object(parsed_response[:data])
    end

    private

    def parsed_response
      return if @raw_response.blank?

      JSON.parse(@raw_response).deep_symbolize_keys
    end

    def resource_class_for(item)
      item[:type].classify.safe_constantize
    end

    def response_item_to_object(item)
      return unless resource_class = resource_class_for(item)

      resource_class.new(item.slice(:id, :attributes))
    end
  end
end
