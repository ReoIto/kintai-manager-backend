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
FactoryBot.define do
  factory :driver do
    sequence(:name) { |i| "test-#{i}" }
    hourly_pay { [4000,4800].sample }
    minimum_guaranteed_salary { [5000,5500].sample }
  end
end
