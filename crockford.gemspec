# frozen_string_literal: true

require_relative "lib/crockford/version"

Gem::Specification.new do |spec|
  spec.name = "crockford"
  spec.version = Crockford::VERSION
  spec.authors = ["iain"]
  spec.email = ["iain@iain.nl"]

  spec.summary = "Crockford's Base32"
  spec.description = "Crockford's Base32"
  spec.homepage = "https://github.com/iain/crockford"
  spec.license = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 3.1.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = File.join(spec.homepage, "blob/HEAD/CHANGELOG.md")
  spec.metadata["bug_tracker_uri"] = File.join(spec.homepage, "issues")
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
