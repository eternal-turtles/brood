# frozen_string_literal: true

## Copyright (c) 2024 John Newton
## SPDX-License-Identifier: Apache-2.0

require_relative "lib/brood/version"

Gem::Specification.new do |spec|
  spec.name = "brood"
  spec.version = Brood::VERSION
  spec.authors = ["John Newton"]
  spec.email = ["jnewton@lisplizards.dev"]

  spec.summary = "Test-fixture object canister"
  spec.description = "Library for generating test-fixture data."
  spec.homepage = "https://github.com/eternal-turtles/brood"
  spec.license = "Apache-2.0"
  spec.required_ruby_version = ">= 3.1.0"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/eternal-turtles/brood"
  spec.metadata["changelog_uri"] = "https://github.com/eternal-turtles/brood/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "fabrication", "~> 2"
end
