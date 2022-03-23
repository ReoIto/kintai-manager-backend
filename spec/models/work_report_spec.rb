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
require 'rails_helper'

RSpec.describe WorkReport, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
