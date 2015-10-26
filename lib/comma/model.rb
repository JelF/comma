require 'comma/type'

module Comma
  # Comma::Model contains all logic you need to include inside your model
  module Model
    # ClassMethods extended when module included
    module ClassMethods
      def _comma_define_attribute(name, type = Comma::Type, **options)
        type.mount!(name, self, options)
        _comma_mountpoints << name
      end

      def comma_extension(type, config = CONFIG[type.name])
        type.new(config).mount!(self)
      end

      private

      def _comma_mountpoints
        @_comma_mountpoints ||= []
      end
    end

    def self.included(base)
      base.extend(ClassMethods)

      class << base
        alias_method ::Comma::CONFIG.attribute_definer_name,
                     :_comma_define_attribute
      end

      CONFIG.autoload_extensions.each { |x| base.include(x) }
    end

    private

    def comma_mountpoints
      self.class.send(:_comma_mountpoints).map { |x| send("#{x}_mountpoint") }
    end
  end
end
