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
require 'rails_helper'

RSpec.describe WorkReport, type: :model do
  describe 'instance methods' do
    let!(:work_report){ create :work_report }

    context '#calc_working_minutes' do
      # 同日に出発/到着が完結するとき
      example 'When departure and arrival are on the same day' do
        work_report.update(
          departure_time: '09:00'.to_time,
          arrival_time: '12:00'.to_time
        )

        working_minutes = work_report.calc_working_minutes
        expect(working_minutes).to eq 180
      end

      # 到着時刻が日を跨ぐとき
      example 'When arrival_time is on the next day' do
        work_report.update(
          departure_time: '23:00'.to_time,
          arrival_time: '01:00'.to_time
        )

        working_minutes = work_report.calc_working_minutes
        expect(working_minutes).to eq 120
      end
    end
  end
end
