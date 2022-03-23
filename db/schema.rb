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

ActiveRecord::Schema[7.0].define(version: 2022_03_23_144658) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", force: :cascade do |t|
    t.string "uid"
    t.string "name", null: false
    t.integer "hourly_pay", default: 0
    t.integer "minimum_guaranteed_salary", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "extra_salaries", force: :cascade do |t|
    t.integer "job_number", null: false
    t.integer "amount", default: 0
    t.integer "over_time_minutes", default: 0
    t.boolean "is_base_extra", default: false, null: false
    t.boolean "is_range_extra", default: false, null: false
    t.bigint "driver_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_extra_salaries_on_driver_id"
  end

  create_table "fixed_salaries", force: :cascade do |t|
    t.integer "total", null: false
    t.bigint "work_report_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_report_id"], name: "index_fixed_salaries_on_work_report_id"
  end

  create_table "work_reports", force: :cascade do |t|
    t.string "name"
    t.date "date", null: false
    t.string "code", null: false
    t.string "guests"
    t.string "departure_point", null: false
    t.string "destination_point", null: false
    t.time "departure_time", null: false
    t.time "arrival_time", null: false
    t.string "formatted_working_time", null: false
    t.integer "job_number", null: false
    t.integer "one_way_kilo_range", default: 0
    t.string "description"
    t.bigint "driver_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_work_reports_on_driver_id"
  end

  add_foreign_key "extra_salaries", "drivers"
  add_foreign_key "fixed_salaries", "work_reports"
  add_foreign_key "work_reports", "drivers"
end
