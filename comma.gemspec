$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'comma/version'

Gem::Specification.new do |spec|
  spec.name = 'comma'
  spec.version = Comma::VERSION
  spec.authors = %w(jelf)
  spec.email = %w(begdory4+comma@gmail.com)

  spec.files = Dir["#{__FILE__}/../lib"]
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'activemodel'
end
