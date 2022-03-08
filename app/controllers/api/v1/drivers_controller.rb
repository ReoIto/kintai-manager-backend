module Api
  module V1
    class DriversController < ApplicationController
      def index
        drivers = Driver.all
        # render json: {status: 'SUCCESS', message: 'There\'s no information you are looking for'}, status: :ok
        render json: {drivers: drivers}, status: :ok
      end
    end
  end
end
