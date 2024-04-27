# frozen_string_literal: true

require "prittbuild/utils/version"
require "prittbuild/utils/log"
require "prittbuild/output"
require "prittbuild/validate"

module PrittBuild
  class Error < StandardError; end

  Project_Dir = "#{File.expand_path("#{File.dirname(__FILE__)}/../../..")}"

  def self.start()
    # Print startup message
    puts "--- PRITTBUILD ---"
    puts "Building the Pritt Project"
  end

  def self.check(deps = {:go => "1.20.0", :dart => "3.1.0", :npm => ""})
    # List dependencies
    deps = {
      :go => "1.20.0",
      :dart => "3.1.0",
      :npm => ""
    }

    # dependencies that aren't available
    unavailable_deps = []

    # dependencies that aren't of desired version
    unversioned_deps = []

    # Iterate and check for each dependency
    deps.each do |key, value|
      # Check if dependency exists
      PrittLogger::log("Checking whether #{key} is installed", PrittLogger::LogLevel::INFO)
      validator = Validator.new()
      available = validator.exists?(key)
      if !available
        unavailable_deps << key
      end

      # Check if dependency has desired version
      PrittLogger::log("Checking whether #{key} is of desired version #{value} or above", PrittLogger::LogLevel::INFO)
      versioned = validator.version?(key, value)
      if !versioned
        unversioned_deps << key
      end
    end

    if unavailable_deps.count != 0
      PrittLogger::log("The following dependencies are not installed: #{unavailable_deps.join(", ")}", PrittLogger::LogLevel::SEVERE)
      PrittLogger::log("Please install them and try again", PrittLogger::LogLevel::SEVERE)
    end
  end

  def self.build_client()

  end

  def self.build_service()

  end

  def self.build_server()

  end

  def self.variables()

  end

  def self.cleanup()

  end

  def self.gen()

  end
end
