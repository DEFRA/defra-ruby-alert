# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem"s version:
require "defra_ruby/alert/version"

Gem::Specification.new do |spec|
  spec.name          = "defra_ruby_alert"
  spec.version       = DefraRuby::Alert::VERSION
  spec.authors       = ["Defra"]
  spec.email         = ["alan.cruikshanks@environment-agency.gov.uk"]
  spec.license       = "The Open Government Licence (OGL) Version 3"
  spec.homepage      = "https://github.com/DEFRA/defra-ruby-alert"
  spec.summary       = "Defra ruby on rails Alert gem"
  spec.description   = "Provides a single source of functionality for initialising and managing Alert in our apps."
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir["{bin,config,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  spec.require_paths = ["lib"]

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise "RubyGems 2.0 or newer is required to protect against public gem pushes." unless spec.respond_to?(:metadata)

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["rubygems_mfa_required"] = "true"

  # Alert catches exceptions, sends them to our Errbit instances
  spec.add_dependency "airbrake"
end
