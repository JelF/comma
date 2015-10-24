module Comma
  module Extensions
    # Something like ActiveSupport::Concern
    module Concern
      attr_reader :config

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

      attr_accessor :default_strategy

      def _included(base)
        strategy = CONFIG[self] && CONFIG[self][:strategy]
        include_strategy!(strategy || default_strategy)

        class_methods = begin
                          const_get(:ClassMethods)
                        rescue
                          nil
                        end
        base.extend(class_methods) if class_methods
        callbacks.each { |callback| base.instance_exec(base, &callback) }
      end

      def include_strategy!(strategy)
        if strategy
          callbacks << strategies.fetch(strategy)
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
    end
  end
end
