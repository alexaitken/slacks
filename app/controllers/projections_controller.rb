class ProjectionsController < ApplicationController
  def index
    @projections = VentSource::Projections.projections.map(&:new)
  end
end
