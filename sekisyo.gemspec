# frozen_string_literal: true

require_relative 'lib/sekisyo/version'

Gem::Specification.new do |spec|
  spec.name = 'sekisyo'
  spec.version = Sekisyo::VERSION
  spec.authors = ['rhiroe']
  spec.email = ['ride.poke@gmail.com']

  spec.summary = 'Rack middleware that blocks HTTP requests that do not follow the Whitelist.'
  spec.description = 'Whitelists can be defined in Yaml files.'
  spec.homepage = 'https://github.com/rhiroe/sekisyo'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/rhiroe/sekisyo'
  spec.metadata['changelog_uri'] = 'https://github.com/rhiroe/sekisyo/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'hashie'
  spec.add_dependency 'rake'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
