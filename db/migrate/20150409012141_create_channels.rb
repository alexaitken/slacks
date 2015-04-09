class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.uuid :aggregate_id
      t.string :name
    end
  end
end
