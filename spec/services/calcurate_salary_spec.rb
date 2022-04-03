require 'rails_helper'

RSpec.describe CalcurateSalary, type: :service do
  let!(:driver){ create(:driver) }
  let(:service){ described_class }
  subject { service.call driver, work_report }

  before do
    stub_const("#{service}::JOB_1_BASE_SALARY", 1000)
    stub_const("#{service}::JOB_2_BASE_SALARY", 1000)
    stub_const("#{service}::JOB_3_BASE_SALARY", 1000)
    stub_const("#{service}::JOB_4_BASE_SALARY_PER_HOUR", 1000)
    stub_const("#{service}::JOB_5_BASE_SALARY_PER_HOUR", 1000)
  end

  describe 'job_number == 1' do
    let!(:work_report) do
      create :work_report,
        driver_id: driver.id,
        job_number: 1
    end

    context 'driverがextra_salaryを持っていない時' do
      it 'JOB_1_BASE_SALARYを返すこと' do
        is_expected.to eq 1000
      end
    end

    context 'driverがextra_salaryを持っている時' do
      let!(:extra_salary) do
        create :extra_salary,
          job_number: 1,
          amount: 500,
          over_time_minutes: 0,
          is_base_extra: true,
          is_range_extra: false,
          driver_id: driver.id
      end

      it 'JOB_1_BASE_SALARYとextra_salaryの合計値を返すこと' do
        is_expected.to eq 1500
      end
    end
  end

  describe 'job_number == 2' do
    let!(:work_report) do
      create :work_report,
        driver_id: driver.id,
        job_number: 2
    end

    subject { service.call driver, work_report }

    context 'driverがextra_salaryを持っていない時' do
      it 'JOB_2_BASE_SALARYを返すこと' do
        is_expected.to eq 1000
      end
    end

    context 'driverがextra_salaryを持っている時' do
      let!(:extra_salary) do
        create :extra_salary,
          job_number: 2,
          amount: 500,
          over_time_minutes: 0,
          is_base_extra: true,
          is_range_extra: false,
          driver_id: driver.id
      end

      it 'JOB_2_BASE_SALARYとextra_salaryの合計値を返すこと' do
        is_expected.to eq 1500
      end
    end
  end

  describe 'job_number == 3' do
    let!(:work_report) do
      create :work_report,
        driver_id: driver.id,
        job_number: 3,
        departure_time: departure_time,
        arrival_time: arrival_time
    end

    let!(:base_extra) do
      create :extra_salary,
        driver_id: driver.id,
        job_number: 3,
        amount: 500,
        is_base_extra: true,
        is_range_extra: false
    end

    context '実働時間が60分未満の時' do
      let!(:departure_time) { '09:00:00'.to_time }
      let!(:arrival_time) { '09:45:00'.to_time }

      it 'JOB_3_BASE_SALARYとbase_extraの合計値を返すこと' do
        is_expected.to eq 1500
      end
    end

    context '実働時間が60分以上の時(残業代が発生する時)' do
      let!(:over_time_extra) do
        create :extra_salary,
          driver_id: driver.id,
          job_number: 3,
          over_time_minutes: over_time_minutes,
          amount: amount,
          is_base_extra: false
      end

      context '残業時間が60~119分の時' do
        let!(:departure_time) { '09:00:00'.to_time }
        let!(:arrival_time) { '10:10:00'.to_time }

        let!(:over_time_minutes) { 60 }
        let!(:amount) { 1000 }

        it 'JOB_3_BASE_SALARY + base_extra + 残業時間60分のover_time_extraの合計値を返すこと' do
          is_expected.to eq 2500
        end
      end

      context '残業時間が120~179分の時' do
        let!(:departure_time) { '09:00:00'.to_time }
        let!(:arrival_time) { '11:10:00'.to_time }

        let!(:over_time_minutes) { 120 }
        let!(:amount) { 2000 }

        it 'JOB_3_BASE_SALARY + base_extra + 残業時間120分のover_time_extraの合計値を返す' do
          total_salary = service.call driver, work_report
          is_expected.to eq 3500
        end
      end

      context '残業時間が180~239分の時' do
        let!(:departure_time) { '09:00:00'.to_time }
        let!(:arrival_time) { '12:10:00'.to_time }

        let!(:over_time_minutes) { 180 }
        let!(:amount) { 3000 }

        it 'JOB_3_BASE_SALARY + base_extra + 残業時間180分のover_time_extraの合計値を返す' do
          is_expected.to eq 4500
        end
      end

      context '残業時間が240分~の時' do
        let!(:departure_time) { '09:00:00'.to_time }
        let!(:arrival_time) { '13:10:00'.to_time }

        let!(:over_time_minutes) { 240 }
        let!(:amount) { 4000 }

        it 'JOB_3_BASE_SALARY + base_extra + 残業時間240分のover_time_extraの合計値を返す' do
          is_expected.to eq 5500
        end
      end
    end

    # 浅野さん
    context 'driver.id == 1' do
      let!(:driver_id_1){ create :driver, id: 1 }
      let!(:base_extra) do
        create :extra_salary,
          job_number: 3,
          amount: 500,
          over_time_minutes: 0,
          is_base_extra: true,
          is_range_extra: false,
          driver_id: driver_id_1.id
      end

      let!(:work_report) do
        create :work_report,
          driver_id: driver_id_1.id,
          job_number: 3,
          departure_time: departure_time,
          arrival_time: arrival_time
      end

      subject { service.call driver_id_1, work_report }

      context '実働時間が60分未満の時' do
        let!(:departure_time) { '09:00:00'.to_time }
        let!(:arrival_time) { '09:45:00'.to_time }

        it 'JOB_3_BASE_SALARYとbase_extraの合計値を返すこと' do
          is_expected.to eq 1500
        end
      end

      context '実働時間が60分以上の時' do
        let!(:departure_time) { '09:00:00'.to_time }
        let!(:arrival_time) { '10:30:00'.to_time }
        let!(:per_kilo_extra) do
          create :extra_salary,
            job_number: 3,
            amount: 500,
            over_time_minutes: 0,
            is_base_extra: false,
            is_range_extra: true,
            driver_id: driver_id_1.id
        end

        before do
          work_report.update one_way_kilo_range: 50
        end

        it '走行km x 1km毎の給与の合計値を返すこと' do
          is_expected.to eq 25000 # 50km * 500yen/1km
        end
      end
    end
  end

  describe 'job_number == 4, 5 (時給計算)' do
    before do
      driver.update!(hourly_pay: 1000, minimum_guaranteed_salary: 5000)
    end

    let!(:work_report) do
      create :work_report,
        driver_id: driver.id,
        job_number: [4,5].sample,
        departure_time: departure_time,
        arrival_time: arrival_time
    end

    subject { service.call driver, work_report }

    context '実働時間が75分以下の時' do
      let(:departure_time) { '09:00:00'.to_time }
      let(:arrival_time) { '09:30:00'.to_time }

      it '最低保証金額を返すこと' do
        is_expected.to eq 5000
      end
    end

    context '実働時間が76分以上の時' do
      let(:departure_time) { '09:00:00'.to_time }
      let(:arrival_time) { '12:00:00'.to_time }

      it '1分単位の実働時間に対して時給計算されること' do
        is_expected.to eq 3000.6000000000004
      end
    end
  end
end