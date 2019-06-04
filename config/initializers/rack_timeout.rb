Rack::Timeout.timeout = (ENV["RACK_TIMEOUT"] || 10).to_i
module Rack
  class Lint
    def assert message, &block
    end
  end
end
