# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_03_170036) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "environment"
    t.string "name"
    t.string "team_owner"
    t.datetime "updated_at", null: false
  end

  create_table "error_events", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.datetime "created_at", null: false
    t.text "error_message"
    t.string "error_type"
    t.datetime "occurred_at"
    t.string "severity"
    t.text "stack_trace"
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_error_events_on_application_id"
  end

  create_table "incident_analyses", force: :cascade do |t|
    t.text "affected_components"
    t.datetime "created_at", null: false
    t.bigint "error_event_id"
    t.text "error_message"
    t.bigint "incident_id"
    t.text "investigation_steps"
    t.jsonb "raw_response", default: {}
    t.text "root_causes"
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["error_event_id"], name: "index_incident_analyses_on_error_event_id"
    t.index ["incident_id"], name: "index_incident_analyses_on_incident_id"
    t.index ["status"], name: "index_incident_analyses_on_status"
  end

  create_table "incident_notes", force: :cascade do |t|
    t.string "author"
    t.text "body"
    t.datetime "created_at", null: false
    t.bigint "incident_id", null: false
    t.datetime "updated_at", null: false
    t.index ["incident_id"], name: "index_incident_notes_on_incident_id"
  end

  create_table "incidents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "error_event_id"
    t.datetime "resolved_at"
    t.string "status", default: "open", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["error_event_id"], name: "index_incidents_on_error_event_id"
    t.index ["status"], name: "index_incidents_on_status"
  end

  add_foreign_key "error_events", "applications"
  add_foreign_key "incident_analyses", "error_events"
  add_foreign_key "incident_analyses", "incidents"
  add_foreign_key "incident_notes", "incidents"
  add_foreign_key "incidents", "error_events"
end
