module Api
  module V1
    class DriversController < ApplicationController
      def index
        render json: {status: 'SUCCESS', message: 'There\'s no information you are looking for'}, status: :ok
      end
    end
  end
end
