require_relative "ansi"

module PrittLogger
  module LogLevel
    NORMAL = 0
    INFO = 1
    WARN = 2
    SEVERE = 3
    FINE = 4
    PROCESS = 5
  end

  def self.log(msg, level=LogLevel::NORMAL)
    case level
    when 0
      puts msg
    when 1
      puts "#{PrittANSI::wrap("[INFO]", PrittANSI::Blue)}: #{msg}"
    when 2
      puts "#{PrittANSI::wrap("[WARNING]", PrittANSI::Yellow)}: #{msg}"
    when 3
      puts "#{PrittANSI::wrap("[ERROR]", PrittANSI::Red)}: #{msg}"
    when 4
      puts "#{PrittANSI::wrap("[FINE]", PrittANSI::Green)}: #{msg}"
    when 5
      puts "#{PrittANSI::wrap("[PROC]", PrittANSI::Cyan)}: #{msg}"
    else
      puts msg
    end
  end
end