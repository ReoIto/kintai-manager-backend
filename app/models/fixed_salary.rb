# == Schema Information
#
# Table name: fixed_salaries
#
#  id             :bigint           not null, primary key
#  deleted_at     :datetime
#  total          :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  work_report_id :bigint           not null
#
# Indexes
#
#  index_fixed_salaries_on_work_report_id  (work_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_report_id => work_reports.id)
#
class FixedSalary < ApplicationRecord
  acts_as_paranoid

  belongs_to :work_report

  validates :total, presence: true
end
