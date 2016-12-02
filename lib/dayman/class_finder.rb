# frozen_string_literal: true
# Finds class according to the resource's context:
#
# module Foo
#   class TestResource
#   end
#
#   module Bar
#     class TestResource
#     end
#   end
# end
#
# Using Dayman to fetch a Foo::Bar::TestResource
# containing a { type: 'test_resources' } object
# ClassFinder will look for the first TestResource
# class starting from Foo::Bar::TestResource's nesting.
# If Foo::Bar::TestResource did not exist, it would find
# Foo::TestResource instead.
#
class ClassFinder
  MODULE_SEPARATOR = '::'

  def initialize(resource:, type:)
    @resource = resource
    @type = type
    @klass = nil
  end

  def find
    namespaces = @resource.name.split(MODULE_SEPARATOR)

    while @klass.blank? && namespaces.present?
      namespaces.pop
      @klass = (namespaces + [@type.classify]).join(MODULE_SEPARATOR).safe_constantize
    end

    @klass
  end
end
