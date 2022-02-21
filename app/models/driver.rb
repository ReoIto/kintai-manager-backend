class Driver < ApplicationRecord
  acts_as_paranoid

  has_many :work_reports, dependent: :destroy
  has_many :extra_salaries, dependent: :destroy

  validates :name, length: {in: 1..15}, presence: true
  validates :hourly_pay, length: {maximum: 6}
end
