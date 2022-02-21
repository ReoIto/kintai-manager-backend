class CreateDrivers < ActiveRecord::Migration[7.0]
  def change
    create_table :drivers do |t|
      t.string :uid, unique: true
      t.string :name, null: false
      t.integer :hourly_pay, default: 0
      t.integer :minimum_guaranteed_salary, default: 0
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
