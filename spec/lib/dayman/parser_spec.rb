# frozen_string_literal: true
require 'spec_helper'

describe Dayman::Parser do
  describe '#collection' do
    let(:resource) { TestResource }
    let(:response) { File.read('spec/support/fixtures/test_resource_collection.json') }

    subject { Dayman::Parser.new(resource: resource, response: response).collection }

    it 'parses a response and returns a collection of resource objects' do
      expect(subject).to be_an(Array)
      expect(subject).to all be_a(TestResource)
    end

    it 'assigns ids' do
      expect(subject.map(&:id)).to eq %w(1 2 3)
    end

    it 'adds missing attributes to the resource class' do
      expect(subject.map(&:title)).to eq [
        'JSON API paints my bikeshed!',
        'JSON API 2: my bikeshed is back!',
        'JSON API 3: bikesheder!'
      ]
    end
  end

  describe '#member' do
    let(:resource) { TestResource }
    let(:response) { File.read('spec/support/fixtures/test_resource_member.json') }

    subject { Dayman::Parser.new(resource: resource, response: response).member }

    it 'parses a response and returns a resource object' do
      expect(subject).to be_a(TestResource)
    end

    it 'assigns an id' do
      expect(subject.id).to eq '1'
    end

    it 'adds missing attributes to the resource class' do
      expect(subject.title).to eq 'JSON API paints my bikeshed!'
    end
  end
end
