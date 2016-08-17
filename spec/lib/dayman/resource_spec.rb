# frozen_string_literal: true
require 'spec_helper'

describe Dayman::Resource do
  describe '.all' do
    subject { TestResource.all }

    it 'fetches a collection' do
      stub_request(:get, 'http://dayman.com/test_resources')

      subject
    end
  end

  describe '.find' do
    subject { TestResource.find(123) }

    it 'fetches a member' do
      stub_request(:get, 'http://dayman.com/test_resources/123')

      subject
    end
  end

  describe '.filter' do
    subject { TestResource.filter(id: 123) }

    it 'builds a request with a filter' do
      expect(subject).to be_a(Dayman::Request)
      expect(subject.filters).to eq(id: 123)
    end

    it 'sends a request with a filter' do
      stub_request(:get, 'http://dayman.com/test_resources?filter[id]=123')

      subject.all
    end

    context 'multiple filters' do
      subject { TestResource.filter(nightman: false).filter(id: 123) }

      it 'is chainable' do
        expect(subject).to be_a(Dayman::Request)
        expect(subject.filters).to eq(id: 123, nightman: false)
      end

      it 'sends a request with all the filters in alphabetical order' do
        stub_request(:get, 'http://dayman.com/test_resources?filter[id]=123&filter[nightman]=false')

        subject.all
      end
    end

    describe '.where' do
      subject { TestResource.where(id: 123) }

      it 'is an alias to .filter' do
        expect(subject).to be_a(Dayman::Request)
        expect(subject.filters).to eq(id: 123)
      end
    end

    describe '#path' do
      context 'single-word resource' do
        subject { Thing.path }

        it { is_expected.to eq('things') }
      end

      context 'multi-word resource' do
        subject { TestResource.path }

        it { is_expected.to eq('test_resources') }
      end
    end
  end
end
