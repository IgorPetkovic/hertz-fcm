# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'hertz/fcm/version'

Gem::Specification.new do |spec|
  spec.name          = 'hertz-fcm'
  spec.version       = Hertz::Fcm::VERSION
  spec.authors       = ['Igor Petkovic']
  spec.email         = ['igor.petkovic@gmail.com']

  spec.summary       = 'A Hertz courier for sending push notifications with Firebase Cloud Messaging.'
  spec.homepage      = 'https://github.com/IgorPetkovic/hertz-fcm'
  spec.license       = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'fcm', '>= 0.0.2', '< 1'
  spec.add_dependency 'hertz', '~> 1.0'
  spec.add_dependency 'rails', '>= 4.0.0', '< 6'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec-activejob'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
end
