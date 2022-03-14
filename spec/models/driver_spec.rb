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
require 'rails_helper'

RSpec.describe Driver, type: :model do
  context 'Validations' do
    let!(:driver) { create :driver }

    context 'presence' do
      it 'nameがあればvalidであること' do
        driver.update name: 'test'
        driver.valid?
        expect(driver).to be_valid
      end
    end

    context '文字数制限' do
      it 'nameは1文字以上であること' do
        driver.update name: ''
        driver.valid?
        expect(driver.errors[:name]).to include("is too short (minimum is 1 character)")
      end

      it 'hourly_payとminimum_guaranteed_salaryは6桁以上だとinvalidであること' do
        driver.update(
          hourly_pay: 1234567,
          minimum_guaranteed_salary: 1234567
        )
        driver.valid?
        expect(driver.errors[:hourly_pay]).to include("is too long (maximum is 6 characters)")
        expect(driver.errors[:minimum_guaranteed_salary]).to include("is too long (maximum is 6 characters)")
      end
    end
  end
end
