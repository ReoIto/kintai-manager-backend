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
  pending "add some examples to (or delete) #{__FILE__}"
end
