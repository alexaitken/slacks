# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150402013500) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "events", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "aggregate_id",    null: false
    t.string   "aggregate_type",  null: false
    t.string   "name",            null: false
    t.integer  "sequence_number", null: false
    t.integer  "version",         null: false
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["aggregate_id", "aggregate_type", "version", "sequence_number"], name: "uniq_aggregate_version", unique: true, using: :btree
  add_index "events", ["aggregate_id", "aggregate_type"], name: "index_events_on_aggregate_id_and_aggregate_type", using: :btree

  create_table "logins", force: :cascade do |t|
    t.uuid    "aggregate_id"
    t.string  "email_address"
    t.integer "sign_ins"
  end

end
