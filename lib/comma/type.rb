require 'comma/type/mounter'

module Comma
  # Describes Comma::Type
  # Type contains all conversion and validation logic
  #
  # The problem: we need to find some way to access instance of mountpoint
  #   because we want to store data in it's instance variables (by design).
  # Possible solutions are
  # 1) Split logic in variables defenition (probably self methods)
  #   and variables access.
  #
  #   Pros: stay simple
  #   Cons: we need some place to store options (probably hash in class var)
  #
  # 2) Supply `self` in defined methods and pass it through our method calls
  #   Pros: more compact
  #   Cons: harder to inherit, and inheritance of this class is a part
  #     of public API
  class Type
    class << self
      def collection
        @collection ||= {}
      end

      def inherited(base)
        collection[base.name] = base
      end

      def mount!(attribute, mountpoint, options)
        Mounter.new(self, attribute, mountpoint, options).mount!
      end
    end

    attr_reader :attribute, :options, :mountpoint

    def initialize(attribute, mountpoint = nil, **options)
      self.attribute = attribute
      self.options = options
      self.mountpoint = mountpoint
    end

    def representation
      mountpoint.instance_variable_get(instance_var)
    end

    def representation=(x)
      mountpoint.instance_variable_set(instance_var, x)
    end

    alias_method :value, :representation
    alias_method :value=, :representation=

    private

    def instance_var
      @instance_var ||= :"@#{attribute}"
    end

    attr_writer :attribute, :options, :mountpoint
  end
end
