class Candlestick < ApplicationRecord

  validates_presence_of :open, :high, :low, :close, :minute, :candlestick_date, :pair

end
