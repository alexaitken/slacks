class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :channel_id
      t.uuid :person_id
      t.string :name
    end
  end
end
