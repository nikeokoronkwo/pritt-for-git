require_relative "utils/log"
require_relative "utils/platform"
require_relative "utils/runner"

require 'fileutils'

module PrittBuild
  def self.build_server(directory, output, config={})
    # Server built in dart
    build_pwd = Dir.pwd
    server_target_file = "bin#{separator}server.dart"
    server_runner = PrittRunner.new()

    PrittLogger::log("Begin Building server and cli", PrittLogger::LogLevel::INFO)

    # Set env
    PrittLogger::log("Setting Configurations", PrittLogger::LogLevel::INFO)
    server_env_file = File.join(directory, ".env")
    server_env_orig = File.read(server_env_file)
    server_env_content = {
      "DATA_JSON" => File.join(config[:data] || "#{output}#{separator}..#{separator}data", "repos.json"),
      "CLIENT_DIR" => config[:client] || "#{output}#{separator}..#{separator}client",
      "SERVICES_DIR" => config[:services] || "#{output}#{separator}..#{separator}bin",
      "DEV" => "false"
    }
    server_env_content = server_env_content.map do |key, value|
      "#{key}=\"#{value}\""
    end.join("\n")
    File.write(server_env_file, server_env_content)

    Dir.chdir(directory)

    # Get dependencies
    PrittLogger::log("Getting Client Dependencies", PrittLogger::LogLevel::INFO)
    server_runner.run("dart pub get")

    # Run build_runner
    PrittLogger::log("Applying Configurations to server code", PrittLogger::LogLevel::INFO)

    server_env_gen_file = File.join(directory, "lib#{separator}gen#{separator}env.g.dart")
    FileUtils.rm(server_env_gen_file) if File.exists?(server_env_gen_file)
    server_runner.run("dart run build_runner build")
    if server_runner.exit_code != 0
      PrittLogger::log("Error applying configurations", PrittLogger::LogLevel::SEVERE)
      exit 1
    end

    # Run prereq
    PrittLogger::log("Running scripts on server", PrittLogger::LogLevel::INFO)
    config[:before].each do |pre|
      # Move to dir for command
      server_script_cmd_dir = File.join(directory, pre[:dir] || ".")
      Dir.chdir(server_script_cmd_dir)

      # Run command
      PrittLogger::log("Running #{pre[:cmd]} at #{server_script_cmd_dir}", PrittLogger::LogLevel::INFO)
      server_runner.run(pre[:cmd])
    end
    Dir.chdir(build_pwd)

    # Run tests
    PrittLogger::log("Running tests on server and cli", PrittLogger::LogLevel::INFO)
    Dir.chdir(directory)
    server_runner.run("dart test")
    if server_runner.exit_code != 0
      PrittLogger::log("Some tests failed on the server", PrittLogger::LogLevel::SEVERE)
      exit server_runner.exit_code
    end

    # Compile
    PrittLogger::log("Compiling into pritt binary", PrittLogger::LogLevel::INFO)
    server_runner.run("dart compile exe -o pritt #{server_target_file}")
    if server_runner.exit_code != 0
      PrittLogger::log("Failed to compile server", PrittLogger::LogLevel::SEVERE)
      exit server_runner.exit_code
    end

    Dir.chdir(build_pwd)

    PrittLogger::log("Reverting and cleaning up", PrittLogger::LogLevel::INFO)
    File.write(server_env_file, server_env_orig)

    # Copy to bin
    server_source_file = File.join(directory, "pritt")
    server_dest_file = File.join(output, "pritt")
    PrittLogger::log("Moving pritt to #{server_dest_file}", PrittLogger::LogLevel::INFO)

    FileUtils.cp(server_source_file, server_dest_file)
    FileUtils.rm(server_source_file)

    # DONE
    PrittLogger::log("pritt has been compiled!", PrittLogger::LogLevel::FINE)
  end
end