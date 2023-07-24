# frozen_string_literal: true

require_relative 'lib/guesty_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'guesty_api'
  spec.version       = GuestyAPI::VERSION
  spec.authors       = ['Michael Babin']
  spec.email         = ['iamsuperman@ukr.net']

  spec.summary       = 'Guesty API wrapper'
  spec.description   = 'Simple abstractions for Guesty API'
  spec.homepage      = 'https://github.com/mihilbabin/guesty_api'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/mihilbabin/guesty_api'
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.88.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.7', '>= 1.7.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.42'
  spec.add_development_dependency 'simplecov', '~> 0.18.5'
  spec.add_development_dependency 'webmock', '~> 3.8', '>= 3.8.3'

  spec.add_dependency 'httparty', '>= 0.17', '< 0.22'
end
