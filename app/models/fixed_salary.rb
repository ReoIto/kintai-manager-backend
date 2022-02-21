class FixedSalary < ApplicationRecord
  acts_as_paranoid

  belongs_to :work_report

  validates :total, presence: true
end
