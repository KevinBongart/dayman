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
  end
end
