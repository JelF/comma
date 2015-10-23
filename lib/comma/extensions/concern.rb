module Comma
  module Extensions
    # Something like ActiveSupport::Concern
    module Concern
      def included(base = nil, &block)
        if block
          callbacks << block
        else
          fail ArgumentError, 'You should supply block' unless base
          _included(base)
        end
      end

      def strategy(name, default: false, &block)
        fail ArgumentError, 'You should supply block' unless block

        strategies[name] = block
        self.default_strategy = name if default
      end

      private

      def _included(base)
        include_strategy!(base)

        class_methods = begin
                          const_get(:ClassMethods)
                        rescue
                          nil
                        end
        base.extend(class_methods) if class_methods
        callbacks.each { |callback| base.instance_exec(base, &callback) }
      end

      def include_strategy!(_base)
        if default_strategy
          callbacks << strategies[default_strategy]
        elsif strategies.any?
          # Hash#first[1] => first value
          callbacks << strategies.first[1]
        end
      end

      def callbacks
        @callbacks ||= []
      end

      def strategies
        @strategies ||= {}
      end

      attr_accessor :default_strategy
    end
  end
end
