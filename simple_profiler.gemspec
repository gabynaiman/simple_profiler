# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_profiler/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_profiler"
  spec.version       = SimpleProfiler::VERSION
  spec.authors       = ['Gabriel Naiman']
  spec.email         = ['gabynaiman@gmail.com']
  spec.summary       = 'Simple Profiler'
  spec.description   = 'Simple Profiler'
  spec.homepage      = 'https://github.com/gabynaiman/simple_profiler'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'datacenter', '~> 0.3'
  spec.add_dependency 'class_config', '~> 0.0'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", '~> 4.7'
  spec.add_development_dependency 'turn', '~> 0.9'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'simplecov'
end