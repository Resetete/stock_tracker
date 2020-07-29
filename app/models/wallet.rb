class Wallet < ApplicationRecord
  belongs_to :user

  def self.get_ticker_options
    %w[ETHEUR BTCEUR].freeze
  end

  def calc_current_profit(ticker, amount_bought, buy_price)
    profit = value_sold_crypto_at_current_price(ticker, amount_bought, buy_price) - amount_bought
    if fees?
      if profit > 0
        current_profit = profit - fees
      else
        current_profit = profit + fees
      end
    else
      profit
    end
  end

  def bought_crypto(amount_bought, buy_price)
    amount_bought / buy_price
  end

  def value_sold_crypto_at_current_price(ticker, amount_bought, buy_price)
    bought_crypto(amount_bought, buy_price) * Stock.new_lookup(ticker).last_price
  end

  def fees
    trading_fee.to_f + selling_fee.to_f
  end

  def fees?
    trading_fee.nil? || selling_fee.nil?
  end
end
