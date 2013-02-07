# -*- encoding: utf-8 -*-

require File.expand_path('../lib/search_path/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "search_path"
  gem.version       = SearchPath::VERSION
  gem.summary       = %q{Allows to define search paths to find files in.}
  gem.description   = %q{Allows to define search paths to find files in.}
  gem.license       = "MIT"
  gem.authors       = ["Thomas Baustert"]
  gem.email         = "business@thomasbaustert.de"
  gem.homepage      = "https://github.com/thomasbaustert/search_path"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  # TODO 09.12.12/17:11/tbaustert remove
  gem.add_development_dependency 'tb_gem_release'

  gem.add_development_dependency 'fakefs'
  gem.add_development_dependency 'rubygems-tasks'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'fuubar'
end

