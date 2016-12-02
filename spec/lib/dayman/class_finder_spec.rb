# frozen_string_literal: true
require 'spec_helper'

describe ClassFinder do
  describe '#find' do
    subject { ClassFinder.new(resource: resource, type: type).find }

    context 'type does not exist' do
      let(:resource) { TestResource }
      let(:type) { 'does_not_exist' }

      it { is_expected.to be_nil }
    end

    context 'type is a namespaced resource defined in several modules' do
      let(:type) { 'namespaced_test_resources' }

      context 'resource is only one level deep' do
        let(:resource) { Foo::NamespacedTestResource }

        it { is_expected.to eq(resource) }
      end

      context 'resource is two levels deep' do
        let(:resource) { Foo::Bar::NamespacedTestResource }

        it { is_expected.to eq(resource) }
      end
    end

    context 'type is a top-level resource' do
      let(:type) { 'test_resources' }

      context 'resource is same as type' do
        let(:resource) { TestResource }

        it { is_expected.to eq(resource) }
      end

      context 'resource has nothing to do with type' do
        let(:resource) { Foo::Bar::NamespacedTestResource }

        it { is_expected.to eq(TestResource) }
      end
    end
  end
end
