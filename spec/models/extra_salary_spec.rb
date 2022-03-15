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
require 'rails_helper'

RSpec.describe ExtraSalary, type: :model do
  context 'Validations' do
    let!(:extra_salary) { create :extra_salary }
    context 'presence' do
      it 'job_numberがnilだとinvalidであること' do
        extra_salary.update job_number: nil
        extra_salary.valid?
        expect(extra_salary).to_not be_valid
      end
    end
  end
end
