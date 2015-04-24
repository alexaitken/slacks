class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :channel_id
      t.integer :member_id
      t.uuid :message_id
      t.text :message

      t.timestamps

      t.index :channel_id
      t.index :message_id
    end
  end
end
