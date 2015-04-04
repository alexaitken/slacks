require "bundler/audit/cli"

namespace :vent_source do
  desc "Run defined projections"
  task run_projections:  :environment do
    VentSource::Projections.run
  end
end
