# frozen_string_literal: true

require_relative "lib/venmo_crypto_connector/version"

Gem::Specification.new do |spec|
  spec.name = "venmo_crypto_connector"
  spec.version = VenmoCryptoConnector::VERSION
  spec.authors = ["Your Name"]
  spec.email = ["your.email@example.com"]

  spec.summary = "Rails engine for Venmo crypto onboarding and education"
  spec.description = "A comprehensive Rails engine providing educational content, wallet integration, and guided onboarding for cryptocurrency users leveraging Venmo's crypto features."
  spec.homepage = "https://github.com/yourusername/venmo_crypto_connector"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yourusername/venmo_crypto_connector"
  spec.metadata["changelog_uri"] = "https://github.com/yourusername/venmo_crypto_connector/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "rails", ">= 6.1.0"
  spec.add_dependency "jwt"

  # Development dependencies
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "database_cleaner-active_record"
  spec.add_development_dependency "shoulda-matchers"
end
