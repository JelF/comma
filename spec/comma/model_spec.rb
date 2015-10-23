describe Comma::Model do
  class MyType < Comma::Type
    def valid?
      value == options.fetch(:should_be, attribute)
    end
  end

  class Subject
    include Comma::Model

    comma_attribute :foo
    comma_attribute :bar, MyType
    comma_attribute :baz, MyType, should_be: 1

    def valid?
      comma_mountpoints.reduce(true) do |acc, x|
        x.respond_to?(:valid?) ? (acc && x.valid?) : acc
      end
    end
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
    it { is_expected.not_to be_valid }
  end
end
