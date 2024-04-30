require_relative "utils/log"
require_relative "utils/platform"
require_relative "utils/runner"

require 'yaml'
require 'fileutils'

module PrittBuild
  def self.build_service(directory, lang, output, config={}, bin_path=nil)
    service_name = config[:name] || File.basename(directory)
    service_bin_name = "pritt-#{service_name}"
    build_pwd = Dir.pwd

    PrittLogger::log("Begin Building #{service_name} pritt service", PrittLogger::LogLevel::INFO)
    file_extension = ""

    case lang
    when "go"
      file_extension = ".go"
    when "dart"
      file_extension = ".dart"
    else
      file_extension = ".#{lang}"
    end

    # Find entrypoint
    PrittLogger::log("Searching for #{service_name} service entrypoint", PrittLogger::LogLevel::INFO)
    service_entrypoint = File.join(directory, config[:entry]) || self.find_entrypoint(directory)
    if service_entrypoint == nil
      PrittLogger::log("Could not find an entrypoint for #{service_name} service", PrittLogger::LogLevel::SEVERE)
      PrittLogger::log("Specify an entrypoint by passing 'config[:entry]'", PrittLogger::LogLevel::SEVERE)
      exit 1
    end

    service_runner = PrittRunner.new()

    # Run prerequisite commands
    config[:before].each do |pre|
      # Move to dir for command
      service_cmd_dir = File.join(directory, pre[:dir] || ".")
      Dir.chdir(service_cmd_dir)

      # Run command
      PrittLogger::log("#{service_name} service: Running #{pre[:cmd]} at #{service_cmd_dir}", PrittLogger::LogLevel::INFO)
      service_runner.run((bin_path != nil && bin_path != "") ? (pre[:cmd]).sub!(lang, bin_path) : pre[:cmd])
    end

    # Change back to main dir
    Dir.chdir(build_pwd)

    # Compile entrypoint
    PrittLogger::log("Compiling #{service_name} service -- pritt-#{service_name}", PrittLogger::LogLevel::INFO)
    case lang
    when "go"
      service_entry_dir = File.dirname(service_entrypoint)
      Dir.chdir(service_entry_dir)
      service_runner.run("#{(bin_path != nil && bin_path != "") ? bin_path : "go"} build -o pritt-#{service_name} .")
      if service_runner.exit_code != 0
        exit service_runner.exit_code
      end
    when "dart"
      if File.basename(File.dirname(service_entrypoint)) == "bin"

        # Run from project root
        service_entry_dir = File.dirname(File.dirname(service_entrypoint))
        Dir.chdir(service_entry_dir)
        service_runner.run("#{(bin_path != nil && bin_path != "") ? bin_path : "dart"} compile bin/#{File.basename(service_entrypoint)} -o pritt-#{service_name}")
        if service_runner.exit_code != 0
          exit service_runner.exit_code
        end
      else
        service_entry_dir = File.dirname(service_entrypoint)
        Dir.chdir(service_entry_dir)
        service_runner.run("#{(bin_path != nil && bin_path != "") ? bin_path : "dart"} compile #{File.basename(service_entrypoint)} -o pritt-#{service_name}")
        if service_runner.exit_code != 0
          exit service_runner.exit_code
        end
      end
    else
      if config[:compile] == nil
        PrittLogger::log("Don't know how to compile #{service_name}", PrittLogger::LogLevel::SEVERE)
        PrittLogger::log("Specify how to compile this service by passing 'config[:compile]'", PrittLogger::LogLevel::FINE)
      else
        service_entry_dir = File.dirname(File.dirname(service_entrypoint))
        Dir.chdir(service_entry_dir)
        service_runner.run(config[:compile])
        if service_runner.exit_code != 0
          exit service_runner.exit_code
        end
      end
    end

    PrittLogger::log("pritt-#{service_name} has been compiled", PrittLogger::LogLevel::FINE)

    # Change back to main dir
    Dir.chdir(build_pwd)

    # Copy compiled binary to build
    service_bin_dest = File.join(output, "pritt-#{service_name}")
    service_bin_src = File.join(directory, "pritt-#{service_name}")

    PrittLogger::log("Moving #{service_name} service to #{service_bin_dest}", PrittLogger::LogLevel::INFO)
    FileUtils.cp(service_bin_src, service_bin_dest)
    FileUtils.rm(service_bin_src)

    PrittLogger::log("#{service_name} service: Build Completed!", PrittLogger::LogLevel::FINE)
  end

  private
  def self.find_entrypoint(dir, lang)
    case lang
    when "go"
      if File.exists?(File.join(dir, "main.go"))
        # Return main.go entry
        return File.join(dir, "main.go")
      else
        # Return src/main.go entry
        return File.join(dir, "src#{separator}main.go")
      end
    when "dart"
      if File.exists?(File.join(dir, "main.dart"))
        # Return main.dart entry
        return File.join(dir, "main.dart")
      else
        bin_files = Dir.entries(File.join(dir, "bin"))
        if bin_files.size == 1
          # Return bin package entry
          return File.join(dir, "bin#{separator}#{bin_files.first}")
        else
          # Get package name and parse the bin file with the given name
          pubspec_file = YAML.load(File.read(File.join(dir, "pubspec.yaml")))
          package_name = pubspec_file["name"]
          return File.join(dir, "bin#{separator}#{package_name}.dart")
        end
      end
    else
      Dir.foreach(dir) do |file|
        next if file == '.' || file == '..'
        if file.include("main")
          return File.join(dir, file)
        end
      end
    end
    return nil
  end
end