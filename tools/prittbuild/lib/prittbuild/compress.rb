require_relative "utils/version"
require_relative "utils/log"

require 'zlib'
require 'archive/tar'

module PrittBuild
  def self.compress_zip(directory, output=nil)
    require 'zip/zip'
    version = self.get_version
    file_name = "pritt-#{version}-#{RUBY_PLATFORM}.zip"
    PrittLogger::log("Zipping Up Build as #{file_name}", PrittLogger::LogLevel::INFO)
    file_dest = File.join(output || File.dirname(directory), file_name)
    Zip::ZipFile.open(file_dest, true) do |zipfile|
      begin
        Dir.foreach(directory) do |file|
          next if file == "." || file == ".."
          zipfile.add(file, File.join(directory, file))
        end
      rescue Exception => e
        PrittLogger::log("An error occured while trying to create zipfile", PrittLogger::LogLevel::SEVERE)
        PrittLogger::log(e, PrittLogger::LogLevel::SEVERE)
        exit 1
      end
    end
    PrittLogger::log("#{file_name} has been created at #{File.dirname(directory)}", PrittLogger::LogLevel::INFO)
  end

  def self.compress_tar(directory)

  end
end