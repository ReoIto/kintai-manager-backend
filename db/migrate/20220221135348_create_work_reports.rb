class CreateWorkReports < ActiveRecord::Migration[7.0]
  def change
    create_table :work_reports do |t|
      t.integer :name
      t.date :date, null: false
      t.string :code, null: false
      t.string :guests
      t.string :departure_point, null: false
      t.string :destination_point, null: false
      t.time :departure_time, null: false
      t.time :arrival_time, null: false
      t.string :formatted_working_time, null: false
      t.integer :job_number, null: false
      t.integer :one_way_kilo_range, default: 0
      t.string :description
      t.references :driver, null: false, foreign_key: true
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
