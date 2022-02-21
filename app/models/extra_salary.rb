# == Schema Information
#
# Table name: extra_salaries
#
#  id                :bigint           not null, primary key
#  amount            :integer          default(0)
#  deleted_at        :datetime
#  is_base_extra     :boolean          default(FALSE), not null
#  is_range_extra    :boolean          default(FALSE), not null
#  job_number        :integer          not null
#  over_time_minutes :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  driver_id         :bigint           not null
#
# Indexes
#
#  index_extra_salaries_on_driver_id  (driver_id)
#
# Foreign Keys
#
#  fk_rails_...  (driver_id => drivers.id)
#
class ExtraSalary < ApplicationRecord
  acts_as_paranoid

  belongs_to :driver

  validates :job_number, presence: true
  validates :is_base_extra, inclusion: {in: [true,false]}
  validates :is_range_extra, inclusion: {in: [true,false]}
end
