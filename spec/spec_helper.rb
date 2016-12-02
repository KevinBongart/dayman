# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dayman'
require 'pry'
require 'webmock/rspec'

class Base < Dayman::Resource
  API_BASE_URL = 'http://dayman.com/'
end

class TestResource < Base
  has_one :author
  has_many :publications
end

class Book < Base
end

class Magazine < Base
end

class Person < Base
end

class Thing < Base
end

module Foo
  module Bar
    class NamespacedResource < Base
    end
  end
end
