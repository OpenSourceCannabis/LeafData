# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'LeafData/version'

Gem::Specification.new do |spec|
  spec.name          = 'LeafData'
  spec.version       = LeafData::VERSION
  spec.authors       = ['Emanuele Tozzato']
  spec.email         = ['et@pharmware.net']

  spec.summary       = %q{Pull and push lab data between a LIMS and LeafData}
  spec.description   = %q{A simple gem to pull lab tests and push results to LeafData }
  spec.homepage      = 'https://420tech.org'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'httparty'
  spec.add_dependency 'bundler', '>= 1.17.3'
  spec.add_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
end
