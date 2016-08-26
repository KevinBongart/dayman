# frozen_string_literal: true
require 'spec_helper'

describe Dayman::Request::Sorting do
  let(:instance) { Dayman::Request.new(TestResource) }

  describe '#sort' do
    context 'single sort field with explicit ascending order' do
      subject { instance.sort(age: :asc) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with sort field in ascending order' do
        expect(subject.sort_fields).to match_array([age: :asc])
      end
    end

    context 'single sort field with implicit ascending order' do
      subject { instance.sort(:age) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with sort field in ascending order' do
        expect(subject.sort_fields).to match_array([age: :asc])
      end
    end

    context 'single sort field in descending order' do
      subject { instance.sort(age: :desc) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with sort field in descending order' do
        expect(subject.sort_fields).to match_array([age: :desc])
      end
    end

    context 'wrong order param' do
      subject { instance.sort(age: :yolo) }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'sort order must be :asc or :desc (defaults to :asc)')
      end
    end

    context 'multiple sort fields' do
      subject { instance.sort(:age, name: :desc) }

      it { is_expected.to be_a(Dayman::Request) }

      it 'builds a request with sort fields' do
        expect(subject.sort_fields).to match_array([{ age: :asc }, { name: :desc }])
      end
    end

    describe '#order' do
      subject { instance.sort(:age) }

      it 'is aliased to #sort' do
        expect(subject.sort_fields).to eq([age: :asc])
      end
    end
  end
end
