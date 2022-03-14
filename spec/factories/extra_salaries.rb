FactoryBot.define do
  factory :extra_salary do
    amount { [500,1000,1500,2000,4000,8000].sample }
    job_number{ [1,2,3,4,5].sample }
    is_base_extra { [true,false].sample }
    is_range_extra { [true,false].sample }
    over_time_minutes { [60,120,180,240].sample }
  end
end
