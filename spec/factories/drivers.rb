FactoryBot.define do
  factory :driver do
    sequence(:name) { |i| "test-#{i}" }
    hourly_pay { [4000,4800].sample }
    minimum_guaranteed_salary { [5000,5500].sample }
  end
end
