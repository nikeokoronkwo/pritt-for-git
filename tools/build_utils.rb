require 'yaml'

server_dir = "./server"

# Separator function to get separator if on windows or not
def separator
  win = (RUBY_PLATFORM =~ /(mingw|mswin)/) != nil
  if win
    return "\\"
  else
    return "/"
  end
end

fallback_node_version = "20.12.0"
fallback_go_version = "1.20.0"
fallback_dart_version = "3.1.0"

def get_versions(project_dir)
  node_version_path = "#{project_dir}#{separator}.versions.yml"
  if File.exists?(node_version_path)
    yaml_file = File.read(node_version_path).strip
    yaml_data = YAML.load(yaml_file)
    return {
      "node": yaml_data["node"],
      "go": yaml_data["go"],
      "dart": yaml_data["dart"]
    }
  else
    return nil
  end
end

# Get desired node version for the project
define_method :get_node_version do |project_dir|
  return get_versions(project_dir)["node"] || fallback_node_version
end

# Get desired dart version for the project
define_method :get_dart_version do |project_dir|
  return get_versions(project_dir)["dart"] || fallback_dart_version
end

# Get desired golang version for project
define_method :get_go_version do |project_dir|
  return get_versions(project_dir)["go"] || fallback_go_version
end

# Parse command-line arguments
def parse_args(cmdname = "build")
  options = {}
  OptionParser.new do |opt|
    opt.banner = """  Pritt Build Tool using the PrittBuild Gem

    Usage: ./#{cmdname} [options]
    """

    # Specify output directory
    opt.on("-o", "--output <dir>", "Output directory to use") do |o|
      unless File.directory?(o)
        puts "You need to specify a directory", "Usage: ./build [options]", "\nUse '-h' or '--help' for more information"
        exit 1
      end
      options[:output] = "#{o}#{separator}build"
    end
    # opt.on("--zip", "generate zip file") do |zip|
    #   options[:zip] = zip
    # end
    # opt.on("--tar", "generate zipped tarball file") do |tar|
    #   options[:tar] = tar
    # end
    opt.on("-v", "--version", "get prittbuild's current version") do |ver|
      options[:version] = ver
    end
  end.parse!
  return options
end