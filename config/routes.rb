Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      namespace :public do

        get 'fetch_candlesticks' => 'candlesticks#fetch_candlesticks'

      end
    end
  end
end
