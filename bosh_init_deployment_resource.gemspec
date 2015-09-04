# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'bosh_init_deployment_resource'
  spec.version       = '0.0.1'
  spec.summary       = 'a gem for things'
  spec.authors       = ['Johannes Engelke']
  spec.email         = 'johannes.engelke@hybris.com'
  spec.homepage      = 'https://github.com/hybris/bosh-init-deployment-resource'
  spec.description   = 'Much longer explanation of the example!'
  spec.license       = ''

  spec.files         = Dir.glob('{lib,bin}/**/*')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'aws-sdk', '~> 2'

  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0'
  spec.add_development_dependency 'rubocop', '~> 0'
end
