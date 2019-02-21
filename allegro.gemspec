# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'allegro/version'

Gem::Specification.new do |spec|
  spec.name          = 'allegro'
  spec.version       = Allegro::VERSION
  spec.licenses      = ['LGPL-3.0']
  spec.authors       = ['Paweł Adamski']
  spec.email         = ['p.adamski@savingcloud.pl']

  spec.summary       = %q{Simple API REST client for allegro.pl}
  spec.homepage      = 'https://github.com/kmi3c/allegro-api'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0'

  spec.add_dependency('json', '~> 0')

  spec.required_ruby_version = '>= 1.9.3'
end
