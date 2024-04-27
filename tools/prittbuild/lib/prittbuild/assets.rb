require_relative "utils/platform"
require_relative "utils/log"

module PrittBuild
  module Assets
    DATA = "repos.json"
  end

  def self.gen(asset, dir, data="")
    PrittLogger::log("Generating #{asset}", PrittLogger::LogLevel::INFO)
    File.open("#{dir}#{PrittBuildUtils::separator}#{asset}", "w") do |file|
      file.puts data
    end
  end
end