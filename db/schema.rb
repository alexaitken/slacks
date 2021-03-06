# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_17_154244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_clients", force: :cascade do |t|
    t.uuid "aggregate_id"
    t.string "name"
    t.uuid "auth_token"
  end

  create_table "channels", force: :cascade do |t|
    t.uuid "aggregate_id"
    t.string "name"
  end

  create_table "events", force: :cascade do |t|
    t.uuid "event_id", default: -> { "uuid_generate_v4()" }
    t.uuid "aggregate_id", null: false
    t.string "aggregate_type", null: false
    t.string "name", null: false
    t.integer "sequence_number", null: false
    t.integer "version", null: false
    t.hstore "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["aggregate_id", "aggregate_type", "version", "sequence_number"], name: "uniq_aggregate_version", unique: true
    t.index ["aggregate_id", "aggregate_type"], name: "index_events_on_aggregate_id_and_aggregate_type"
    t.index ["event_id"], name: "index_events_on_event_id"
  end

  create_table "logins", force: :cascade do |t|
    t.uuid "aggregate_id"
    t.string "email_address"
    t.integer "sign_ins"
    t.string "string"
    t.string "name"
  end

  create_table "members", force: :cascade do |t|
    t.integer "channel_id"
    t.uuid "person_id"
    t.string "name"
    t.boolean "active", default: true
  end

  create_table "messages", force: :cascade do |t|
    t.integer "channel_id"
    t.integer "member_id"
    t.uuid "message_id"
    t.text "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["channel_id"], name: "index_messages_on_channel_id"
    t.index ["message_id"], name: "index_messages_on_message_id"
  end

  create_table "projection_stores", force: :cascade do |t|
    t.string "name", null: false
    t.uuid "last_event_id"
    t.datetime "last_event_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
