# frozen_string_literal: true
require 'spec_helper'

describe Dayman::Parsers::CollectionParser do
  describe '#parse' do
    let(:resource) { TestResource }
    let(:response) { File.read('spec/support/fixtures/test_resource_collection.json') }

    subject { described_class.new(resource: resource, response: response).parse }

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

    context 'with included resources' do
      let(:response) { File.read('spec/support/fixtures/test_resource_collection_with_included_relationships.json') }

      it 'builds the defined associations' do
        expect(subject.first.author).to be_a(Person)
        expect(subject.first.author.id).to eq('42')
        expect(subject.first.author.first_name).to eq('Nina')
        expect(subject.first.author.last_name).to eq('Simone')

        expect(subject.first.publications).to be_an(Array)
        book, magazine = subject.first.publications

        expect(book).to be_a(Book)
        expect(book.id).to eq('123')
        expect(book.title).to eq('Everything Is Illuminated')

        expect(magazine).to be_a(Magazine)
        expect(magazine.id).to eq('123')
        expect(magazine.title).to eq('#sports')
      end
    end
  end
end
