module PrittANSI
  Red = "\033[31m"
  Green = "\033[32m"
  Yellow = "\033[33m"
  Blue = "\033[34m"
  Magenta = "\033[35m"
  Cyan = "\033[36m"
  White = "\033[37m"
  Default = "\033[39m"

  Reset = "\033[0m"

  def self.wrap(msg, colour=PrittANSI::Default)
    return colour + msg + PrittANSI::Reset
  end

end