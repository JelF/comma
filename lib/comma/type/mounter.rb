module Comma
  class Type
    # Comma::Type::Mounter describes logic of mounting Type onto class.
    # It defines mountpoint and optionaly reader and writer methods
    # Configure is stored inside mountpoint defenition
    class Mounter
      def initialize(type, attribute, mountpoint, options)
        self.type = type
        self.attribute = attribute
        self.mountpoint = mountpoint
        self.options = options
      end

      def mount!
        define_mountpoint!

        define_reader! if options.fetch(:define_reader, true)
        define_writer! if options.fetch(:define_writer, true)
      end

      protected

      def mountpoint_name
        @mountpoint_name ||= :"#{attribute}_mountpoint"
      end

      private

      attr_accessor :type, :attribute, :mountpoint, :options

      def mountpoint_method(ivar)
        builder = -> (target) { type.new(attribute, target, options) }

        proc do
          if instance_variable_defined?(ivar)
            instance_variable_get(ivar)
          else
            instance_variable_set(ivar, builder.call(self))
          end
        end
      end

      def define_mountpoint!
        method = mountpoint_method(:"@#{attribute}_mountpoint")

        mountpoint.instance_exec(mountpoint_name) do |name|
          define_method(name, &method)
          private(name)
        end
      end

      def define_reader!
        # TODO: find workaround to DRY next line
        mountpoint_name = self.mountpoint_name

        mountpoint.send(:define_method, attribute) do
          send(mountpoint_name).value
        end
      end

      def define_writer!
        mountpoint_name = self.mountpoint_name

        mountpoint.send(:define_method, "#{attribute}=") do |x|
          send(mountpoint_name).value = x
        end
      end
    end
  end
end
