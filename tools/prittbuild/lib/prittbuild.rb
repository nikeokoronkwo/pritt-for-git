# frozen_string_literal: true

require "prittbuild/version"
require "prittbuild/log"

module Prittbuild
  class Error < StandardError; end

  def self.start
    self.log "PRITTBUILD"
    self.log "Building the Pritt Project"
  end
end
