require "bundler/audit/cli"

namespace :vent_source do
  namespace :projections do
    desc "Run defined projections"
    task run: :environment do
      VentSource::Projections.run
    end

    desc "Reset a projection PROJECTION=<name>"
    task reset: :environment do
      raise 'provide PROJECTION=name' unless ENV['PROJECTION']
      VentSource::Projections.reset(ENV['PROJECTION'])
    end

    namespace :reset do
      desc "Reset all projections"
      task all: :environment do
        VentSource::Projections.reset_all
      end
    end
  end
end
