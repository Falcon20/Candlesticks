class CandlestickService < CandlestickBaseService

  TRADES_URL = 'https://public.coindcx.com/market_data/trade_history?pair='

  def self.get_recent_trade_data_from_api(trade_pair)
    api_response = RestClient.get(TRADES_URL + "#{trade_pair}&limit=300")
    JSON.parse(api_response)
  end

  def self.fetch_candlesticks(params)
    trade_pair = params[:pair].present? ? params[:pair] : nil
    candlestick_date = params[:candlestick_date].present? ? params[:candlestick_date].to_datetime : nil
    candlestick_minutes = params[:minutes].present? ? params[:minutes].to_i : 1
    raise 'trade pair can not be null' if trade_pair.nil?
    raise 'candlestick date can not be null' if candlestick_date.nil?
    candlestick_data = Candlestick.where(minute: 1, pair: trade_pair)
    if candlestick_data.count > 0
      return {
        success: true,
        data: candlestick_data.as_json
      }
    else
      candlesticks = []
      trade_data = self.get_recent_trade_data_from_api(params[:pair])
      trade_data = trade_data.map!(& :deep_symbolize_keys)
      open = nil
      high = nil
      low = nil
      close = nil
      minute = DateTime.strptime(trade_data[0][:T].to_s,'%s').minute.to_i
      trade_data.each do |trade|
        current_minute = DateTime.strptime(trade[:T].to_s,'%s').minute.to_i
        current_trade_price = trade[:p] / trade[:q]
        if current_minute > minute + candlestick_minutes
          minute = current_minute
          candlesticks << {
            open: open,
            high: high,
            low: low,
            close: current_trade_price,
            minute: 1,
            pair: trade_pair,
            candlestick_date: DateTime.strptime(trade[:T].to_s,'%s')
          }
          open = nil
          high = nil
          low = nil
          close = nil
        else
          if open.nil?
            open = current_trade_price
          end
          if high.nil? || current_trade_price > high
            high = current_trade_price
          end
          if low.nil? || (current_trade_price) < low
            low  = current_trade_price
          end
          close = current_trade_price
        end
      end
      candlesticks << {
        open: open,
        close: close,
        high: high,
        low: low,
        minute: 1,
        pair: trade_pair,
        candlestick_date: DateTime.strptime(trade_data.last[:T].to_s,'%s')
      }
    end
    Candlestick.create!(candlesticks)
    return {
      success: true,
      data: candlesticks.as_json
    }
  end
end
