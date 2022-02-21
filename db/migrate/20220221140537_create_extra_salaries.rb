class CreateExtraSalaries < ActiveRecord::Migration[7.0]
  def change
    create_table :extra_salaries do |t|
      t.integer :job_number, null: false
      t.integer :amount, default: 0
      t.integer :over_time_minutes, default: 0
      t.boolean :is_base_extra, default: false, null: false
      t.boolean :is_range_extra, default: false, null: false
      t.references :driver, null: false, foreign_key: true
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
