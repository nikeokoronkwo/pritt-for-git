class PrittPlatform
  def self.windows
    (RUBY_PLATFORM =~ /(mingw|mswin)/) != nil
  end

  def self.macos
    (RUBY_PLATFORM =~ /(darwin)/) != nil
  end

  def self.linux
    (RUBY_PLATFORM =~ /(linux)/) != nil
  end

  def architecture
    RUBY_PLATFORM
  end
end