module Comma
  # Handless all comma configuration
  # Do not use Comma::Model here because of circular depedencies
  class Config
    attr_reader :extensions
    attr_accessor :attribute_definer_name

    def initialize
      @extensions = {}
      @attribute_definer_name = :comma_attribute
    end

    def load(file)
      data = Yaml.load_file(file)
      data.each { |key, value| public_send("#{key}=", value) }
    end

    def register_extension(extension, config = {})
      if extension.is_a?(String)
        extension = Comma::Extensions.const_get(extension)
      end

      extensions[extension] = config
    end

    def extenstions=(hash)
      @extenstions = {}
      hash.each { |x| register_extension(*x) }
    end

    def autoload_extensions
      extensions
        .select { |_key, value| value.fetch(:autoload, false) }
        .values
    end

    def [](key)
      extensions.fetch(key, {})
    end
  end
end
