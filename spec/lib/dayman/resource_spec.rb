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

  describe '.includes' do
    subject { TestResource.includes(:songs) }

    it 'builds a request with included resources' do
      expect(subject).to be_a(Dayman::Request)
      expect(subject.included_resources).to match_array([:songs])
    end

    it 'sends a request with included resources' do
      stub_request(:get, 'http://dayman.com/test_resources?include=songs')

      subject.all
    end

    context 'multiple resources in chained methods' do
      subject { TestResource.includes(:songs).includes(:hat) }

      it 'is chainable' do
        expect(subject).to be_a(Dayman::Request)
      end

      it 'builds a request with all the included resources' do
        expect(subject.included_resources).to match_array([:songs, :hat])
      end

      it 'sends a request with all the resources' do
        stub_request(:get, 'http://dayman.com/test_resources?include=songs,hat')

        subject.all
      end
    end

    context 'multiple resources in one method' do
      subject { TestResource.includes(:songs, :hat) }

      it 'builds a request with all the included resources' do
        expect(subject.included_resources).to match_array([:songs, :hat])
      end

      it 'sends a request with all the resources' do
        stub_request(:get, 'http://dayman.com/test_resources?include=songs,hat')

        subject.all
      end
    end

    context 'nested resources' do
      subject { TestResource.includes(:songs, hat: [:colors, :arrow]) }

      it 'builds a request with all the included resources' do
        expect(subject.included_resources).to match_array([:songs, hat: [:colors, :arrow]])
      end

      it 'sends a request with all the resources' do
        stub_request(:get, 'http://dayman.com/test_resources?include=songs,hat.colors,hat.arrow')

        subject.all
      end
    end
  end

  describe '.fields' do
    context 'single fieldset' do
      subject { TestResource.fields(:name).all }

      it 'sends a request with selected fieldsets' do
        stub_request(:get, 'http://dayman.com/test_resources?fields[test_resources]=name')

        subject
      end
    end

    context 'multiple fieldsets' do
      subject { TestResource.fields([:name, :age]).all }

      it 'sends a request with selected fieldsets' do
        stub_request(:get, 'http://dayman.com/test_resources?fields[test_resources]=name,age')

        subject
      end
    end

    context 'multiple fieldsets for multiple resources in one method' do
      subject { TestResource.fields(test_resources: [:name, :age], book: [:title]).all }

      it 'sends a request with selected fieldsets' do
        stub_request(:get, 'http://dayman.com/test_resources?fields[test_resources]=name,age&fields[book]=title')

        subject
      end
    end

    context 'multiple fieldsets for multiple resources in chained methods' do
      subject do
        TestResource.fields(test_resources: :name).fields(book: :title).fields(test_resources: :age).all
      end

      it 'sends a request with selected fieldsets' do
        stub_request(:get, 'http://dayman.com/test_resources?fields[test_resources]=name,age&fields[book]=title')

        subject
      end
    end
  end

  describe '.filter' do
    context 'single filter' do
      subject { TestResource.filter(id: 123).all }

      it 'sends a request with a filter' do
        stub_request(:get, 'http://dayman.com/test_resources?filter[id]=123')

        subject
      end
    end

    context 'multiple filters in one method' do
      subject { TestResource.filter(nightman: false, id: 123).all }

      it 'sends a request with filters' do
        stub_request(:get, 'http://dayman.com/test_resources?filter[id]=123&filter[nightman]=false')

        subject
      end
    end

    context 'multiple filters in chained methods' do
      subject { TestResource.filter(nightman: false).filter(id: 123).all }

      it 'sends a request with filters' do
        stub_request(:get, 'http://dayman.com/test_resources?filter[id]=123&filter[nightman]=false')

        subject
      end
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
