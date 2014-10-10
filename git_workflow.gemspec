# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_workflow/version'

Gem::Specification.new do |spec|
  spec.name          = "git_workflow"
  spec.version       = GitWorkflow::VERSION
  spec.authors       = ["Ryan McGarvey"]
  spec.email         = ["zephyr-eng+ryan@gust.com"]
  spec.summary       = %q{git flow workflow tool}
  spec.description   = %q{git flow wofkflow tool for those that use gitflow}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
