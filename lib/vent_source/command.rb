module VentSource::Command
  extend ActiveSupport::Concern
  include ActiveModel::Model
  include VentSource::IdGeneration

  attr_reader :id, :created_at, :meta

  def initialize(attr = {})
    super
    @id ||= generate_id
    @created_at ||= Time.now
    @meta ||= {}
  end
end
