require 'comma/extensions/validation'

describe Comma::Model do
  class MyType < Comma::Type
    def valid?
      value == options.fetch(:should_be, attribute)
    end
  end

  class Subject
    include Comma::Model
    include Comma::Extensions::Validation

    comma_attribute :foo
    comma_attribute :bar, MyType
    comma_attribute :baz, MyType, should_be: 1
  end

  subject { Subject.new }

  describe 'valid model' do
    before { subject.foo = 123 }
    before { subject.bar = :bar }
    before { subject.baz = 1 }
    it { is_expected.to be_valid }
  end

  describe 'invalid model' do
    before { subject.foo = 123 }
    before { subject.bar = :bar }
    before { subject.baz = :baz }

    it 'proxies errors' do
      expect(subject).not_to be_valid
      expect(subject.errors.messages)
        .to match(baz: [include('invalid_mountpoint')])
    end
  end
end
