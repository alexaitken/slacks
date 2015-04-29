class VentSource::EventsController < ApplicationController
  def index
    @events = VentSource::ArEventStore::Event.all
    apply_filters
  end

  def show
    @event = VentSource::ArEventStore::Event.find_by(event_id: params[:id])
    raise ActiveRecord::RecordNotFound unless @event
  end

  private

  def apply_filters
    if params[:filter_type]
      @events = @events.where(params[:filter_type] => params[:filter_value])
    end
  end
end
