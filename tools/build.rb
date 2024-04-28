# Copyright (C) 2024 Nike Okoronkwo
# All Rights Reserved

# Add prittbuild gem to path
$LOAD_PATH << File.expand_path('../prittbuild/lib', __FILE__)

# Imports
require 'optparse'
require 'prittbuild'

require_relative "build_utils"

def main()
  options = parse_args("build")

  if options[:version]
    puts "PrittBuild v#{PrittBuild.get_version} on #{RUBY_PLATFORM}"
    exit 0
  end
  # Derive build directories
  pritt_build_dir = PrittBuild::BuildDir.new(File.expand_path(options[:output] || "#{Dir.home}#{separator}.pritt#{separator}build"))

  # Derive project directory
  pritt_project_dir = "#{File.expand_path("#{File.dirname(__FILE__)}#{separator}..")}"

  # Start build service
  PrittBuild.start()

  # Check for dependencies
  PrittBuild.check({
    :npm => get_node_version(pritt_project_dir),
    :go => get_go_version(pritt_project_dir),
    :dart => get_dart_version(pritt_project_dir)
  })

  # Create destinations
  PrittBuild.create_dir(pritt_build_dir)

  # Deduce client directory
  pritt_client_dir = "#{pritt_project_dir}#{separator}client"

  # Build client
  PrittBuild.build_client(pritt_client_dir, pritt_build_dir.client_dir)

  # Build Assets
  PrittBuild.gen(PrittBuild::Assets::DATA, pritt_build_dir.data_dir, "[]")

  # Build Services
  pritt_services_dir = "#{pritt_project_dir}#{separator}services"
  Dir.foreach(pritt_services_dir) do |file|
    service = File.join(pritt_services_dir, file)
    next if file == '.' || file == '..'
    next if !File.directory?(service)

    case file
    # For now only "git" has been done
    when "git"
      # build the git service
      PrittBuild.build_service(service, "go", pritt_build_dir.bin_dir, {
        :entry => "main.go",
        :before => [{
          :cmd => "go fmt",
          :dir => "."
        }, {
          :cmd => "go mod tidy",
          :dir => "package"
        }, {
          :cmd => "go get",
          :dir => "package"
        }]
      })
    else
      next
    end
  end

  pritt_server_dir = "#{pritt_project_dir}#{separator}server"

  # Build the server
  PrittBuild.build_server(pritt_server_dir, pritt_build_dir.bin_dir, {
    :client => pritt_build_dir.client_dir,
    :services => pritt_build_dir.bin_dir,
    :data => pritt_build_dir.data_dir,
    :before => [{
      :cmd => "dart fix --apply",
      :dir => "."
    }, {
      :cmd => "dart format .",
      :dir => "."
    }]
  })

  # PrittBuild.compress_zip(pritt_build_dir.main_dir) if options[:zip]

  # Clean up build
  PrittBuild.cleanup(pritt_build_dir.main_dir)
end

main()