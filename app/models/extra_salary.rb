class ExtraSalary < ApplicationRecord
  acts_as_paranoid

  belongs_to :driver

  validates :job_number, presence: true
  validates :is_base_extra, inclusion: {in: [true,false]}
  validates :is_range_extra, inclusion: {in: [true,false]}
end
