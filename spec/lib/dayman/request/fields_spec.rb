# frozen_string_literal: true
require 'spec_helper'

describe Dayman::Request::Fields do
  let(:instance) { Dayman::Request.new(TestResource) }

  describe '#fields' do
    context 'single fieldset' do
      subject { instance.fields(:name) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with selected fields' do
        expect(subject.fieldsets).to eq(test_resources: [:name])
      end
    end

    context 'multiple fieldsets' do
      subject { instance.fields([:name, :age]) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with selected fields' do
        expect(subject.fieldsets).to eq(test_resources: [:name, :age])
      end
    end

    context 'multiple fieldsets for multiple resources in one method' do
      subject { instance.fields(test_resources: [:name, :age], book: [:title]) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with selected fields' do
        expect(subject.fieldsets).to eq(test_resources: [:name, :age], book: [:title])
      end
    end

    context 'multiple fieldsets for multiple resources in chained methods' do
      subject do
        instance.fields(test_resources: :name).fields(book: :title).fields(test_resources: :age)
      end

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with selected fields' do
        expect(subject.fieldsets).to eq(test_resources: [:name, :age], book: [:title])
      end
    end
  end
end
