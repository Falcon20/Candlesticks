class CreateCandlesticks < ActiveRecord::Migration[6.0]
  def up
    create_table :candlesticks, id: :uuid do |t|
      t.float :open, null: false
      t.float :close, null: false
      t.float :low, null: false
      t.float :high, null: false
      t.datetime :candlestick_date, null: false
      t.integer :minute, null: false
      t.string :pair, null: false

      t.timestamps

      t.index [:pair, :candlestick_date, :minute]
    end
  end

  def down
    drop_table :candlesticks
  end
end
