# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'bosh-init_deployment_resource'
  spec.version       = '0.0.1'
  spec.summary       = 'a gem for things'
  spec.authors       = ['Johannes Engelke']

  spec.files         = Dir.glob('{lib,bin}/**/*')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'aws-sdk', '~> 2'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
