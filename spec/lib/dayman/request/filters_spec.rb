# frozen_string_literal: true
require 'spec_helper'

describe Dayman::Request::Filters do
  let(:instance) { Dayman::Request.new(TestResource) }

  describe '#filter' do
    context 'single filter' do
      subject { instance.filter(id: 123) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with a filter' do
        expect(subject.filters).to eq(id: 123)
      end
    end

    context 'multiple filters in one method' do
      subject { instance.filter(nightman: false, id: 123) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with filters' do
        expect(subject.filters).to eq(id: 123, nightman: false)
      end
    end

    context 'multiple filters in chained methods' do
      subject { instance.filter(nightman: false).filter(id: 123) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with filters' do
        expect(subject.filters).to eq(id: 123, nightman: false)
      end
    end
  end

  describe '#where' do
    subject { instance.where(id: 123) }

    it 'is aliased to #filter' do
      expect(subject.filters).to eq(id: 123)
    end
  end
end
