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

module PrittBuild
  class Error < StandardError; end

  # Start the build process
  def self.start()
    # Print startup message
    puts "--- PRITTBUILD ---"
    puts "Building the Pritt Project"
  end



  def self.variables()

  end

  def self.cleanup()

  end


end
