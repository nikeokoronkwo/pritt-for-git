require_relative "ansi"

module Prittbuild
  module LogLevel
    NORMAL = 0
    INFO = 1
    WARN = 2
    SEVERE = 3
    FINE = 4
  end

  def self.log msg, level=LogLevel::NORMAL
    case level
    when 0
      puts "[NORMAL]: #{msg}"
    when 1
      puts "#{PrittANSI::wrap "[INFO]", PrittANSI::Blue}: #{msg}"
    else
      puts msg
    end
  end
end