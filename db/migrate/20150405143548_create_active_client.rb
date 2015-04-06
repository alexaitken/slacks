class CreateActiveClient < ActiveRecord::Migration
  def change
    create_table :active_clients do |t|
      t.uuid :aggregate_id
      t.string :name
      t.uuid :auth_token
    end
  end
end
