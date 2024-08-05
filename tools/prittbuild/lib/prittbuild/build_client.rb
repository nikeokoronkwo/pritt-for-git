require_relative "utils/log"
require_relative "utils/runner"

require 'pathname'
require 'json'
require 'fileutils'

module PrittBuild
  # Builds the pritt client
  # directory - The client directory
  # output - The client output directory
  #
  def self.build_client(directory, output, yarn=false)
    # The dist build for client - built with Vite
    client_dist_build = "#{directory}/dist"
    client_npm_bin = "npm"
    client_npx_bin = "npx"
    builder_pwd = Dir.pwd
    client_runner = PrittRunner.new()

    PrittLogger::log("Begin Building Client", PrittLogger::LogLevel::INFO)

    client_package_json_raw = File.read("#{directory}/package.json")
    client_package_json = JSON.parse(client_package_json_raw)

    client_run_commands = client_package_json["scripts"]

    # Changed to client directory
    Dir.chdir(directory)

    # Get deps
    PrittLogger::log("Getting Client Dependencies", PrittLogger::LogLevel::INFO)
    client_runner.run(yarn ? "yarn install" : "#{client_npm_bin} install")

    # Format Code
    PrittLogger::log("Formatting Client Code", PrittLogger::LogLevel::INFO)
    client_format_command = client_run_commands["format"]

    client_format = yarn ? "yarn format" : "#{client_npx_bin} #{client_format_command}"
    client_runner.run(client_format)

    PrittLogger::log("Setting Up Client Environment", PrittLogger::LogLevel::INFO)

    # Nothing for now

    # Build and Run Tests
    PrittLogger::log("Building Client and Running Tests", PrittLogger::LogLevel::INFO)
    client_build_command = client_run_commands["build"]

    client_build = yarn ? "yarn build" : "#{client_npx_bin} #{client_build_command}"
    client_runner.run(client_build)

    if !File.exists?("#{directory}/dist") || Dir.empty?("#{directory}/dist")
      PrittLogger::log("An error occured while building the client", PrittLogger::LogLevel::SEVERE)
      PrittLogger::log("Check the 'PROC' logs and try again", PrittLogger::LogLevel::SEVERE)
    end

    # Copy Client to directory
    PrittLogger::log("Moving Client build to #{output}", PrittLogger::LogLevel::INFO)

    Dir.chdir(builder_pwd)
    Dir.foreach(client_dist_build) do |file|
      next if file == '.' || file == '..'

      source_file = File.join(client_dist_build, file)
      destination_file = File.join(output, file)

      if File.directory?(source_file)
        FileUtils.cp_r(source_file, destination_file)
      else
        # Move files to build
        FileUtils.cp(source_file, destination_file)
      end
    end
    FileUtils.rm_rf(client_dist_build)

    PrittLogger::log("Client has been built successfully!", PrittLogger::LogLevel::INFO)
  end
end