# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'infostrada/version'

Gem::Specification.new do |spec|
  spec.name          = 'infostrada'
  spec.version       = Infostrada::VERSION
  spec.authors       = ['Ricardo Otero']
  spec.email         = ['oterosantos@gmail.com']
  spec.summary       = 'Infostrada Football API wrapper.'
  spec.description   = 'Wrapper for the Infostrada Football API using httparty.'
  spec.homepage      = 'https://github.com/rikas/infostrada-api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.2', '>= 10.2.2'
  spec.add_development_dependency 'reek', '~> 1.3', '>= 1.3.7'
  spec.add_development_dependency 'rubocop', '~> 0.20', '>= 0.20.1'
  spec.add_development_dependency 'pry', '~> 0.9', '>= 0.9.12'

  spec.add_dependency 'httparty', '~> 0.13', '>= 0.13.0'
  spec.add_dependency 'colored', '~> 1.2'
  spec.add_dependency 'tzinfo', '>= 1.1.0'
  spec.add_dependency 'eventmachine', '~> 1.0', '>= 1.0.3'
end