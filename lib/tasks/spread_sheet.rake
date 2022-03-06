namespace :spread_sheet do
  desc 'Import sheet / Update sheet'
  task update: :environment do
    UpdateSpreadSheet.call
  end
end