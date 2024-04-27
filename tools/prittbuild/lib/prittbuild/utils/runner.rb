require_relative "log"

# A class representing a runner for running commands and handling the given error messages
class PrittRunner
  def initialize()
    @exit_code = 0
  end

  # Exit code of process
  def exit_code
    @exit_code
  end

  # Run given command `cmd`
  def run(cmd)
    result = `#{cmd}`
    if result.nil? || result.empty?
      PrittLogger::log("Command \"#{cmd}\" failed ", PrittLogger::LogLevel::SEVERE)
      error_message = $?.to_s.split("\n").last
      PrittLogger::log(error_message, PrittLogger::LogLevel::INFO)
      @exit_code = 1
    else
      result.each_line { |line| PrittLogger::log(line, PrittLogger::LogLevel::PROCESS) }
      @exit_code = 0
    end
  end

  # Close Runner
  def close()
    @exit_code = 0
  end
end
