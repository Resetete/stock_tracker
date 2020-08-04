class Wallet < ApplicationRecord
  #validates :ticker, presence: true
  #validates :amount_bought, presence: true
  #validates :buy_price, presence: true

  belongs_to :user

  def self.get_ticker_options
    %w[ETH BTC USDC XLM BCH ZEC REP BAT LINK XRP LTC ZRX EOS OXT DAI XTZ COMP KNC ALGO ATOM DASH ETC MKR OMG YCC].sort.freeze
  end

  def calc_current_profit(ticker, amount_bought, buy_price, currency ='EUR')
    if value_sold_crypto_at_current_price(ticker, amount_bought, buy_price, currency ='EUR').nil?
      nil
    else
      profit = value_sold_crypto_at_current_price(ticker, amount_bought, buy_price, currency ='EUR') - amount_bought
      if fees?
        if profit > 0
          profit - fees
        else
          profit + fees
        end
      else
        profit
      end
    end
  end

  def bought_crypto(amount_bought, buy_price)
    amount_bought / buy_price
  end

  def value_sold_crypto_at_current_price(ticker, amount_bought, buy_price, currency = 'EUR')
    begin
      bought_crypto(amount_bought, buy_price) * Stock.new_crypto_lookup(ticker, currency = 'EUR').last_price
    rescue => e
      p "Error occured: #{e}"
      nil
    end
  end

  def fees
    trading_fee.to_f + selling_fee.to_f
  end

  def fees?
    trading_fee.nil? || selling_fee.nil?
  end
end
