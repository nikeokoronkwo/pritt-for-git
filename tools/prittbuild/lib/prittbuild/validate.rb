require_relative "utils/log"

module PrittBuild
  class Validator
    def initialize()
    end

    def exists?(program)
      if system("where #{program} > /dev/null 2>&1")
        PrittLogger::log("Error: #{program} doesn't exist", PrittLogger::LogLevel::SEVERE)
        return false
      else
        PrittLogger::log("#{program} present", PrittLogger::LogLevel::FINE)
        return true
      end
    end

    def version?(program, version=nil)
      if version != nil && version != ""
        if program == :go
          v = `go version`.match(/go(\d+\.\d+\.\d+)/)[1]
          vObj = Version.new(v)
          vTarget = Version.new(version)
          if vObj < vTarget
            PrittLogger::log("Error: #{program} is of version #{v}, which is less than the desired version #{version}", PrittLogger::LogLevel::SEVERE)
            return false
          else
            PrittLogger::log("#{program} is of desired version - #{v}", PrittLogger::LogLevel::FINE)
            return true
          end
        elsif program == :dart
          v = `dart --version`.match(/\b\d+\.\d+\.\d+\b/)[0]
          vObj = Version.new(v)
          vTarget = Version.new(version)
          if vObj < vTarget
            PrittLogger::log("Error: #{program} is of version #{v}, which is less than the desired version #{version}", PrittLogger::LogLevel::SEVERE)
            return false
          else
            PrittLogger::log("#{program} is of desired version - #{v}", PrittLogger::LogLevel::FINE)
            return true
          end
        elsif program == :npm
          v = `node --version`.match(/\d+\.\d+\.\d+/)[0]
          vObj = Version.new(v)
          vTarget = Version.new(version)
          if vObj < vTarget
            PrittLogger::log("Error: #{program} is of version #{v}, which is less than the desired version #{version}", PrittLogger::LogLevel::SEVERE)
            return false
          else
            PrittLogger::log("#{program} is of desired version - #{v}", PrittLogger::LogLevel::FINE)
            return true
          end
        end
      else
        PrittLogger::log("#{program} is of desired version", PrittLogger::LogLevel::FINE)
        return true
      end
    end

  end

  class Version
    def initialize(version="1.0.0")
      parts = version.split(".")
      if parts.last =~ /#{Regexp.escape("-")}/
        final = parts.last
        parts.pop
        parts << final.split("-")
      end
      @major = parts[0].to_i
      @minor = parts[1].to_i
      @patch = parts[2].to_i
      @pre_release = parts[3]
    end

    def >(other)
      @major > other.major || (@major == other.major && @minor > other.minor) || (@major == other.major && @minor == other.minor && @patch > other.patch)
    end

    def <(other)
      @major < other.major || (@major == other.major && @minor < other.minor) || (@major == other.major && @minor == other.minor && @patch < other.patch)
    end

    def >=(other)
      @major >= other.major || (@major == other.major && @minor >= other.minor) || (@major == other.major && @minor == other.minor && @patch >= other.patch)
    end

    def <=(other)
      @major <= other.major || (@major == other.major && @minor <= other.minor) || (@major == other.major && @minor == other.minor && @patch <= other.patch)
    end

    def major
      @major
    end

    def minor
      @minor
    end

    def patch
      @patch
    end

    def pre_release
      @pre_release
    end
  end
end
