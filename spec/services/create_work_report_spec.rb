require 'rails_helper'

RSpec.describe CreateWorkReport, type: :service do
  let!(:driver) { create :driver, name: 'hoge' }
  let!(:row) do
    {
      name: name_in_row || 'hoge',
      date: '2022/02/10',
      code: '1234',
      guests: 'guests_1, guests_2',
      departure_point: '成田空港',
      destination_point: '東京駅',
      departure_time: '9:00:00',
      arrival_time: '12:00:00',
      job_number: '1',
      description: 'This is description',
      one_way_kilo_range: 45
    }
  end
  let!(:result) { described_class.call row }

  context '正常系' do
    context '渡ってきた値に不備がない時' do
      let!(:name_in_row) { 'hoge' }

      it 'ServiceClassが返却されること' do
        expect(result).to be_instance_of ServiceResult
      end

      it 'ServiceClass.success? がtrueであること' do
        expect(result.success?).to be true
      end

      it 'ServiceClass.errorsが空配列であること' do
        expect(result.errors.empty?).to be true
      end

      it 'ServiceClass.dataにWorkReportオブジェクトが格納されていること' do
        expect(result.data).to be_instance_of WorkReport
      end

      it '作成されたWorkReportがvalidであること' do
        expect(result.data.valid?).to be true
      end
    end
  end

  context '異常系' do
    context '渡ってきた引数に不備がある時' do
      context '存在しないDriverの名前が渡ってきた時' do
        let!(:name_in_row) { 'piyo' }

        it 'ServiceClassが返却されること' do
          expect(result).to be_instance_of ServiceResult
        end

        it 'ServiceClass.success? がfalseであること' do
          expect(result.success?).to be false
        end

        it 'ActiveRecord::RecordNotFoundとそのdriver名が返却されること' do
          expect(result.errors.present?).to be true
          expect(result.errors).to include(ActiveRecord::RecordNotFound)
          expect(result.errors).to include('piyo') # driver.nameは'hoge'しか存在しない
        end

        it 'ServiceClass.dataがnilであること' do
          expect(result.data.nil?).to be true
        end
      end

      context '必須の値が存在しない時' do
        # Todo: このテストに関係ない変数を定義している
        let!(:row) do
          {
            name: 'hoge',
            date: '',
            code: '1234',
            guests: 'guests_1, guests_2',
            departure_point: '成田空港',
            destination_point: '東京駅',
            departure_time: '9:00:00',
            arrival_time: '12:00:00',
            job_number: '1',
            description: 'This is description',
            one_way_kilo_range: 45
          }
        end

        it 'ServiceClass.success? がfalseであること' do
          expect(result.success?).to be false
        end

        it 'ServiceClass.errorsにエラー内容が格納されていること' do
          expect(result.errors.present?).to be true
          expect(result.errors).to include({:date=>["can't be blank"]})
        end
      end
    end
  end
end