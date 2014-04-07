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
  spec.description   = spec.summary
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'httparty', '~> 0.12'
  spec.add_dependency 'colored'
  spec.add_dependency 'rb-readline'
  spec.add_dependency 'tzinfo'
  spec.add_dependency 'eventmachine'

  spec.add_development_dependency 'pry'
end