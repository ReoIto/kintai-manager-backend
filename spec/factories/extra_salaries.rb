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
FactoryBot.define do
  factory :extra_salary do
    amount { [500,1000,1500,2000,4000,8000].sample }
    job_number{ [1,2,3,4,5].sample }
    is_base_extra { [true,false].sample }
    is_range_extra { [true,false].sample }
    over_time_minutes { [60,120,180,240].sample }

    association :driver, factory: :driver
  end
end
