# frozen_string_literal: true
require 'spec_helper'

describe Dayman::Parsers::MemberParser do
  describe '#parse' do
    let(:resource) { TestResource }
    let(:response) { File.read('spec/support/fixtures/test_resource_member.json') }

    subject { described_class.new(resource: resource, response: response).parse }

    it 'parses a response and returns a resource object' do
      expect(subject).to be_a(TestResource)
    end

    it 'assigns an id' do
      expect(subject.id).to eq '1'
    end

    it 'adds missing attributes to the resource class' do
      expect(subject.title).to eq 'JSON API paints my bikeshed!'
    end

    context 'with included resources' do
      let(:response) { File.read('spec/support/fixtures/test_resource_member_with_included_relationships.json') }

      it 'builds the defined associations' do
        expect(subject.author).to be_a(Person)
        expect(subject.author.id).to eq('42')
        expect(subject.author.first_name).to eq('Nina')
        expect(subject.author.last_name).to eq('Simone')

        expect(subject.publications).to be_an(Array)
        book, magazine = subject.publications

        expect(book).to be_a(Book)
        expect(book.id).to eq('123')
        expect(book.title).to eq('Everything Is Illuminated')

        expect(magazine).to be_a(Magazine)
        expect(magazine.id).to eq('123')
        expect(magazine.title).to eq('#sports')
      end

      it 'does not build associations for undefined classes or data not included' do
        expect(subject.publications.length).to eq(2)
      end

      it 'does not build associations for associations not present in resource' do
        expect(subject).not_to respond_to(:association_not_present_in_resource)
      end
    end
  end
end
