FactoryBot.define do
  factory :fixed_salary do
    total { Random.rand(1000..20000) }

    association :work_report, factory: :work_report
  end
end
