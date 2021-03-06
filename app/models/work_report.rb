# == Schema Information
#
# Table name: work_reports
#
#  id                     :bigint           not null, primary key
#  arrival_time           :time             not null
#  code                   :string           not null
#  date                   :date             not null
#  deleted_at             :datetime
#  departure_point        :string           not null
#  departure_time         :time             not null
#  description            :string
#  destination_point      :string           not null
#  formatted_working_time :string           not null
#  guests                 :string
#  job_number             :integer          not null
#  name                   :string
#  one_way_kilo_range     :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  driver_id              :bigint           not null
#
# Indexes
#
#  index_work_reports_on_driver_id  (driver_id)
#
# Foreign Keys
#
#  fk_rails_...  (driver_id => drivers.id)
#
class WorkReport < ApplicationRecord
  acts_as_paranoid

  belongs_to :driver
  has_one :fixed_salary, dependent: :destroy

  validates :name, length: {in: 1..15}, presence: true
  validates :code, length: {in: 1..15}, presence: true
  validates :date, presence: true
  validates :departure_point, presence: true
  validates :destination_point, presence: true
  validates :departure_time, presence: true
  validates :arrival_time, presence: true
  validates :job_number, presence: true

  def calc_working_minutes
    departure_time = self.departure_time
    arrival_time = self.arrival_time

    # 日を跨いでいる場合の考慮
    if arrival_time < departure_time
      arrival_time = arrival_time.tomorrow
    end

    # 夜勤の場合などはマイナスの値になってしまうため、絶対値を取得する
    ((arrival_time - departure_time) / 60).abs
  end
end
