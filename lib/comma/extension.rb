require 'comma/delegation'

module Comma
  class Extension
    extend Delegation

    class << self
      def strategy(name, default: false, &block)
        fail ArgumentError, 'You should supply block' unless block

        strategies[name] = block
        self.default_strategy = name if default
      end

      def callback(&block)
        fail ArgumentError, 'You should supply block' unless block
        callbacks << block
      end

      attr_accessor :default_strategy

      def strategies
        @strategies ||= {}
      end

      def callbacks
        @callbacks ||= {}
      end
    end

    delegate :strategies, :default_strategy, :name, to: :class

    attr_reader :config

    def initialize(config = CONFIG[name])
      @config = config
    end

    def mount!(base)
      include_strategy!
      callbacks.each { |callback| base.instance_exec(base, &callback) }
    end

    private

    def include_strategy!
      if strategy
        callbacks << strategies.fetch(strategy)
      elsif
        # Hash#first[1] => first value
        callbacks << strategies.first[1]
      end
    end

    def callbacks
      @callbacks ||= 
        self.class.callbacks.map { |callback| instance_exec(&callback) }
    end

    def class_methods
      # Not yet implemented
    end

    def strategy
      config.fetch(:strategy, default_strategy)
    end
  end
end