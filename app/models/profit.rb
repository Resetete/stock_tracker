class Profit < ApplicationRecord
  belongs_to :user

  def self.daily_profit(user)
    tickers.each do |ticker|
      find_wallet_entries(ticker).each do |wallet_entry|
        date_range(user).each do |date|
          p "Date range: #{date_range(user)}"
          p "Ticker: #{ticker}"
          p "Date: #{date}"

          profit = calc_profit(wallet_entry.ticker, date, wallet_entry.amount_bought, wallet_entry.buy_price, wallet_entry.trading_fee, wallet_entry.selling_fee)
          begin
            Profit.create(ticker: wallet_entry.ticker, profit: profit, date: date, user_id: wallet_entry.user_id)
          rescue => e
            p "Error occured: #{e}"
            nil
          end
        end
      end
    end
  end



  def daily_total_profit
  end


  private

  def self.start_date(user)
    Profit.where(user_id: user).order(date: :desc).first.date + 1.day
    #DateTime.new(2020, 8, 20, 0, 0, 0) # should be the first bought_on where total profit in profits table is empty
  end

  def self.end_date
    #DateTime.new(2020, 8, 21, 0, 0, 0) # should be the first bought_on where total profit in profits table is empty
    DateTime.yesterday
  end

  def already_fetched? # checks if date is already in database
    Profit.where(user_id: user).order(date: :desc).first.date == end_date
  end

  def self.tickers
    Wallet.distinct.pluck(:ticker)
  end

  def self.date_range(user)
    start_date(user)..end_date
  end

  def self.find_wallet_entries(ticker)
    Wallet.where(ticker: ticker)
  end

  def self.call_crypto_api_historical(ticker_symbol, timestamp, currency = 'EUR')
    # https://min-api.cryptocompare.com/documentation?key=Historical&cat=dataPriceHistorical
    # convert DateTime object to unixtime --> DateTime.new().to_time.to_i
    begin
      api_url = URI.parse("https://min-api.cryptocompare.com/data/pricehistorical?fsym=#{ticker_symbol}&tsyms=#{currency}&ts=#{timestamp.to_time.to_i}")
      response = Net::HTTP.get_response(api_url)
      json_response = JSON.parse(response.body)[ticker_symbol][currency]
    rescue => e
      p "Error when fetching historical course: #{e}"
      p ticker_symbol
      p timestamp
      nil
    end
  end

  def self.calc_profit(ticker, date, amount_bought, buy_price, trading_fee, selling_fee)
    if call_crypto_api_historical(ticker, date).nil?
      nil
    else
      profit = bought_crypto(amount_bought, buy_price) * call_crypto_api_historical(ticker, date) - amount_bought
      if fees?(trading_fee, selling_fee)
        if profit > 0
          profit - fees(trading_fee, selling_fee)
        else
          profit + fees(trading_fee, selling_fee)
        end
      else
        profit
      end
    end
  end

  def self.bought_crypto(amount_bought, buy_price)
    amount_bought / buy_price
  end

  def self.fees(trading_fee, selling_fee)
    trading_fee.to_f + selling_fee.to_f
  end

  def self.fees?(trading_fee, selling_fee)
    trading_fee.nil? || selling_fee.nil?
  end

end
