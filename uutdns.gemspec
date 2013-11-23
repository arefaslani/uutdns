# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uutdns/version'

Gem::Specification.new do |spec|
  spec.name          = "uutdns"
  spec.version       = Uutdns::VERSION
  spec.authors       = ["Aref Aslani"]
  spec.email         = ["arefaslani@gmail.com"]
  spec.description   = %q{Simple DNS Client built for Internet Engineering course in Urmia University of Technology}
  spec.summary       = %q{Simple DNS Client}
  spec.homepage      = "https://github.com/arefaslani/uutdns"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
