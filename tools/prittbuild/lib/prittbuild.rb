# Utilities
require "prittbuild/utils/version"
require "prittbuild/output"

# Commands used
require "prittbuild/check"
require "prittbuild/build_client"
require "prittbuild/create_dir"
require "prittbuild/assets"
require "prittbuild/build_service"
require "prittbuild/build_server"

# require "prittbuild/compress"

module PrittBuild
  class Error < StandardError; end

  # Start the build process
  def self.start()
    # Print startup message
    puts "--- PRITTBUILD ---", "Building the Pritt Project"
  end

  def self.variables()
    # Implement later
  end

  def self.cleanup(directory)
    # Print end message
    puts "\nThe prittbuild project has been built successfully!", "Find the build at #{directory}", ""
    puts "--- PRITTBUILD ---"
  end
end
