require_relative "utils/log"

require 'fileutils'

module PrittBuild
  def self.create_dir(directory)
    PrittLogger::log("Creating build destinations", PrittLogger::LogLevel::INFO)
    if File.exists?(directory.main_dir)
      FileUtils.rm_rf(directory.main_dir)
    end
    Dir.mkdir(directory.main_dir)
    Dir.mkdir(directory.client_dir)
    Dir.mkdir(directory.data_dir)
    Dir.mkdir(directory.bin_dir)
    PrittLogger::log("Created!", PrittLogger::LogLevel::FINE)
  end
end