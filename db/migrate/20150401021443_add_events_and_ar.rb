class AddEventsAndAr < ActiveRecord::Migration
  def change
    enable_extension 'hstore'
    enable_extension 'uuid-ossp'

    create_table :events, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.uuid :aggregate_id, null: false
      t.string :aggregate_type, null: false
      t.string :name, null: false
      t.integer :sequence_number, null: false
      t.integer :version, null: false
      t.hstore :data

      t.timestamps
    end

    add_index :events, [:aggregate_id, :aggregate_type]
    add_index :events, [:aggregate_id, :aggregate_type, :version, :sequence_number], unique: true, name: 'uniq_aggregate_version'
  end
end
