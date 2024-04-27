require_relative "utils/platform"
require_relative "utils/log"

module PrittBuild
  module Assets
    DATA = "repos.json"
  end

  def self.gen(asset, dir)
    PrittLogger::log("Generating #{asset}", PrittLogger::LogLevel::INFO)
    File.create("#{dir}#{PrittBuildUtils::separator}#{asset}")
  end
end