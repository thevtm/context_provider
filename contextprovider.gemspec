# frozen_string_literal: true

require_relative 'lib/context_provider/version'

Gem::Specification.new do |spec|
  spec.name          = 'context_provider'
  spec.version       = ContextProvider::VERSION
  spec.authors       = ['Vinicius Manjabosco']
  spec.email         = ['vinicius.manjabosco@lendahand.com']

  spec.summary       = 'Ruby version of the context pattern from React.'
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/thevtm/context_provider'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/thevtm/contextprovider/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'concurrent-ruby', '>= 1.0.0'
end
