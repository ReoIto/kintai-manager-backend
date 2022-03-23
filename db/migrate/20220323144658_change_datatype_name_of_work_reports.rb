class ChangeDatatypeNameOfWorkReports < ActiveRecord::Migration[7.0]
  def change
    change_column :work_reports, :name, :string
  end
end
