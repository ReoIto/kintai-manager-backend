# == Schema Information
#
# Table name: drivers
#
#  id                        :bigint           not null, primary key
#  deleted_at                :datetime
#  hourly_pay                :integer          default(0)
#  minimum_guaranteed_salary :integer          default(0)
#  name                      :string           not null
#  uid                       :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
class Driver < ApplicationRecord
  acts_as_paranoid

  has_many :work_reports, dependent: :destroy
  has_many :extra_salaries, dependent: :destroy

  validates :name, length: {in: 1..15}, presence: true
  validates :hourly_pay, length: {maximum: 6}
end
