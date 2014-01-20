require File.expand_path('../lib/infostrada/version', __FILE__)

Gem::Specification.new do |s|
  s.authors       = ['Ricardo Otero']
  s.email         = ['oterosantos@gmail.com']
  s.description   = s.summary = 'Infostrada Football API wrapper'
  s.homepage      = ''
  s.license       = 'LGPL-3.0'

  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files         = Dir['{lib}/**/*.rb', 'bin/*', '*.md']
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.name          = 'infostrada'
  s.require_paths = ['lib']
  s.version       = Infostrada::VERSION

  s.add_dependency 'httparty', '~> 0.12'
end