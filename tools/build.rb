# Copyright (C) 2024 Nike Okoronkwo
# All Rights Reserved

# Add prittbuild gem to path
$LOAD_PATH << File.expand_path('../prittbuild/lib', __FILE__)

# Imports
require 'optparse'
require 'prittbuild'

fallback_node_version = "20.12.0"
fallback_go_version = "1.20.0"
fallback_dart_version = "3.1.0"

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

# Get desired node version for the project
def get_node_version(project_dir)
  node_version_path = "#{project_dir}#{separator}.node-version"
  if File.exists?(node_version_path)
    version = File.read(node_version_path).strip
    return version
  else
    return fallback_node_version
  end
end

# Get desired dart version for the project
def get_dart_version(project_dir)
  dart_version_path = "#{project_dir}#{separator}.dart-version"
  if File.exists?(dart_version_path)

  elsif File.exists("#{project_dir}")

# Parse command-line arguments
def parse_args()
  options = {}
  OptionParser.new do |opt|
    opt.banner = """  Pritt Build Tool using the PrittBuild Gem

    Usage: ./build [options]
    """

    # Specify output directory
    opt.on("-o", "--output <dir>", "Output directory to use") do |o|
      unless File.directory?(o)
        puts "You need to specify a directory", "Usage: ./build [options]", "\nUse '-h' or '--help' for more information"
        exit 1
      end
      options[:output] = "#{o}#{separator}build"
    end
  end.parse!
  return options
end

def main()
  options = parse_args()
  # Derive build directories
  pritt_build_dir = PrittBuild::BuildDir.new(File.expand_path(options[:output] || "#{Dir.home}/.pritt/build"))

  puts pritt_build_dir.data_dir
  puts PrittBuild::Project_Dir
  PrittBuild.check
end

main()