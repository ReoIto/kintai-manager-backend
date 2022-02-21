class CreateFixedSalaries < ActiveRecord::Migration[7.0]
  def change
    create_table :fixed_salaries do |t|
      t.integer :total, null: false
      t.references :work_report, null: false, foreign_key: true
      t.datetime :deleted_at, after: :work_report
      t.timestamps
    end
  end
end
