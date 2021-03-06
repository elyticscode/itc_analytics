# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'itc_analytics/version'

Gem::Specification.new do |spec|
  spec.name          = "itc_analytics"
  spec.version       = ITCAnalytics::VERSION
  spec.authors       = ["Steele Nelson"]
  spec.email         = ["steele@elytics.com"]

  spec.summary       = %q{Get analytics from iTunesConnect}
  spec.description   = <<-EOF 
    ITCAnalytics uses the undocumented iTunesConnect API's to retreive 
    analytics for iOS and tvOS apps.
  EOF
  spec.homepage      = "https://www.elytics.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.14"
end
