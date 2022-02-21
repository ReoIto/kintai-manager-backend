class WorkReport < ApplicationRecord
  acts_as_paranoid

  belongs_to :driver
  has_one :fixed_salary, dependent: :destroy

  validates :name, length: {in: 1..15}, presence: true
  validates :code, length: {in: 1..15}, presence: true
  validates :departure_point, presence: true
  validates :destination_point, presence: true
  validates :departure_time, presence: true
  validates :arrival_time, presence: true
  validates :job_number, presence: true
end
