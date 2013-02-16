# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slim/curly/version'

Gem::Specification.new do |gem|
  gem.name          = "slim-curly"
  gem.version       = Slim::Curly::VERSION
  gem.authors       = ["Andreas Haller"]
  gem.email         = ["andreashaller@gmail.com"]
  gem.description   = "Generate Handlebars/Mustache/curly templates using Slim."
  gem.homepage      = "https://github.com/ahx/slim-curly"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency("slim", ["~> 2.0.0.pre.6"])
  gem.add_development_dependency "rake"
end
