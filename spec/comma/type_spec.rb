require 'comma/type'

describe Comma::Type do
  describe 'mounting' do
    let(:klass) { Class.new }
    subject { klass.new }

    specify 'default' do
      Comma::Type.mount!(:foo, klass, {})

      subject.foo = :bar
      expect(subject.instance_variable_get(:@foo)).to eq(:bar)
      expect(subject.foo).to eq :bar
    end

    specify 'no writer' do
      Comma::Type.mount!(:foo, klass, define_writer: false)

      expect(subject).not_to be_respond_to(:foo=)
      subject.instance_variable_set(:@foo, :bar)
      expect(subject.foo).to eq :bar
    end

    specify 'no reader' do
      Comma::Type.mount!(:foo, klass, define_reader: false)

      subject.foo = :bar
      expect(subject.instance_variable_get(:@foo)).to eq(:bar)
      expect(subject).not_to be_respond_to(:foo)
    end
  end
end
