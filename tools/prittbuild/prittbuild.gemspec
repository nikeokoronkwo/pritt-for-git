# frozen_string_literal: true

require_relative "lib/prittbuild/version"

Gem::Specification.new do |spec|
  spec.name = "prittbuild"
  spec.version = PrittBuild::get_version
  spec.authors = ["--add"]
  spec.email = ["nikechukwu@gmail.com"]

  spec.summary = "Prittbuild is a gem used mainly and internally in building Pritt and related projects"
  spec.description = "The Pritt Project's build system/gem, used for building Pritt and it's fellow packages"
  spec.homepage = "https://github.com/nikeokoronkwo/pritt/tree/main/tools/prittbuild"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/nikeokoronkwo/pritt/tree/main/tools/prittbuild"
  spec.metadata["changelog_uri"] = "https://github.com/nikeokoronkwo/pritt/tree/main/tools/prittbuild/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
