require 'comma/type/mounter'

module Comma
  # Describes Comma::Type
  # Type contains all conversion and validation logic
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

    def value
      representation
    end

    def value=(x)
      self.representation = x
    end

    private

    def instance_var
      @instance_var ||= :"@#{attribute}"
    end

    attr_writer :attribute, :options, :mountpoint
  end
end
