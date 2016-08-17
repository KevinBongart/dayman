# frozen_string_literal: true
require 'spec_helper'

describe Dayman::Request::Includes do
  let(:instance) { Dayman::Request.new(TestResource) }

  describe '#includes' do
    context 'single resource' do
      subject { instance.includes(:songs) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with included resource' do
        expect(subject.included_resources).to match_array([:songs])
      end
    end

    context 'multiple resources in one method' do
      subject { instance.includes(:songs, :hat) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with all the included resources' do
        expect(subject.included_resources).to match_array([:songs, :hat])
      end
    end

    context 'multiple resources in chained methods' do
      subject { instance.includes(:songs).includes(:hat) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with all the included resources' do
        expect(subject.included_resources).to match_array([:songs, :hat])
      end
    end

    context 'nested resources' do
      subject { instance.includes(:songs, hat: [:colors, :arrow]) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with all the included resources' do
        expect(subject.included_resources).to match_array([:songs, hat: [:colors, :arrow]])
      end
    end
  end
end
