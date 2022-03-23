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
FactoryBot.define do
  factory :work_report do
    sequence(:name) { |i| "test-#{i}" }
    date { '2022-01-01'.to_date }
    code { 'init_code' }
    job_number { [1,2,3,4,5].sample }
    departure_point { 'init_departure_point' }
    destination_point { 'init_destination_point' }
    departure_time { '09:00:00'.to_time }
    arrival_time { '12:00:00'.to_time }
    formatted_working_time { '03:00:00' }

    association :driver, factory: :driver
  end
end
