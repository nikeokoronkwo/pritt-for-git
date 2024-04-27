require_relative "utils/log"
require_relative "validate"

module PrittBuild
  def self.check(deps = {:go => "1.20.0", :dart => "3.1.0", :npm => ""})

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
      exit 1
    end

    if unversioned_deps.count != 0
      PrittLogger::log("The following dependencies are not up to date: #{unversioned_deps.join(", ")}", PrittLogger::LogLevel::SEVERE)
      PrittLogger::log("Please update them and try again", PrittLogger::LogLevel::SEVERE)
      exit 1
    end

    PrittLogger::log("Check Done. Begin build...", PrittLogger::LogLevel::INFO)
  end
end
