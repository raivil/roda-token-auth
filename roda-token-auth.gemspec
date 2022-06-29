
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "roda/plugins/token_auth/version"

Gem::Specification.new do |spec|
  spec.name          = "roda-token-auth"
  spec.version       = Roda::RodaPlugins::TokenAuth::VERSION
  spec.authors       = ["Ronaldo Raivil"]
  spec.email         = ["raivil@gmail.com"]

  spec.summary       = %(Plugin that adds token authentication methods to Roda)
  spec.description   = %(Plugin that adds token authentication methods to Roda)
  spec.homepage      = "https://github.com/raivil/roda-token-auth"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "roda", ">= 2.0", "< 4.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rack-test", "2.0.2"
  spec.add_development_dependency "json", "~> 2.0"
  spec.add_development_dependency "simplecov", "~> 0.11"
end
