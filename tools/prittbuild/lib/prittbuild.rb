# frozen_string_literal: true

# Commands used
require "prittbuild/check"
require "prittbuild/build_client"
require "prittbuild/create_dir"
require "prittbuild/assets"

module PrittBuild
  class Error < StandardError; end

  def self.start()
    # Print startup message
    puts "--- PRITTBUILD ---"
    puts "Building the Pritt Project"
  end

  def self.build_service()

  end

  def self.build_server()

  end

  def self.variables()

  end

  def self.cleanup()

  end


end
