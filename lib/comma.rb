require 'comma/version'
require 'comma/config'
require 'comma/model'

# This file describes Comma manifest
module Comma
  CONFIG = Config.new

  def self.configure
    yield CONFIG
  end
end
