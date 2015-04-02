class CreateProjectionStore < ActiveRecord::Migration
  def change
    create_table :projection_stores do |t|
      t.string :name, null: false
      t.uuid :last_event_id
      t.datetime :last_event_created_at
      t.timestamp
    end
  end
end
