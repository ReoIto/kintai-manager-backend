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
