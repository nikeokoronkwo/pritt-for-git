# frozen_string_literal: true

module PrittBuild
  def self.get_version()
    versions_txt_file = File.expand_path("#{File.dirname(File.dirname(File.dirname(File.dirname(__FILE__))))}#{separator}..#{separator}..#{separator}scripts#{separator}version.txt")
    versions_txt_file_contents = File.read(versions_txt_file).strip
    return versions_txt_file_contents
  end
end
