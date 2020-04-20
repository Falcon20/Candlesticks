class Api::V1::Public::CandlesticksController < ApplicationController

  before_action :set_candlestick_service

  def fetch_candlesticks
    response = @candlestick_service.fetch_candlesticks(fetch_candlesticks_params)
    render json: response
  end

  private

  def set_candlestick_service
    @candlestick_service ||= CandlestickService
  end

  def fetch_candlesticks_params
    params.permit(:pair, :candlestick_date,:minute)
  end
end
