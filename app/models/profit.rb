class Profit < ApplicationRecord
  belongs_to :user

  def self.daily_profit(current_user)
    tickers.each do |ticker|
      find_wallet_entries(ticker, current_user).each do |wallet_entry|
        p "Date range: #{date_range(wallet_entry)}"
        date_range(wallet_entry).each do |date|
          p "date range: #{date}"
          p "user: #{current_user}"
          profit = calc_profit(wallet_entry.ticker, date, wallet_entry.amount_bought, wallet_entry.buy_price, wallet_entry.trading_fee, wallet_entry.selling_fee)
          p "Profit: #{profit}"
          max_retries = 3
          times_retried = 0
          begin
            Profit.create(ticker: wallet_entry.ticker, profit: profit, date: date, user_id: wallet_entry.user_id)
          rescue => e
            if times_retried < max_retries
              times_retried += 1
              puts "Error occured: #{e}; retry #{times_retried}/#{max_retries}"
              byebug
              retry
            else
              puts "Exiting script; it is unlikely to solve the error of catching data"
              exit(1)
            end
          end
        end
      end
    end
  end

  private

  def self.start_date(wallet_entry)
    #Wallet.where(user_id: current_user, ticker: ticker, buy_date: buy_date).order(date: :desc).first.buy_date + 1.day
    #DateTime.new(2020, 8, 28, 0, 0, 0) # should be the first bought_on where total profit in profits table is empty
    Wallet.find(wallet_entry.id).buy_date.to_date + 1.day
  end

  def self.end_date
    #DateTime.new(2020, 9, 2, 0, 0, 0) # should be the first bought_on where total profit in profits table is empty
    DateTime.yesterday
  end

  def already_fetched?(ticker) # checks if date is already in database --> TO DO!
    Profit.where(user_id: current_user, ticker: ticker).order(date: :desc).first.date == end_date
  end

  def self.tickers
    Wallet.distinct.pluck(:ticker)
  end

  def self.date_range(wallet_entry)
    start_date(wallet_entry)..end_date
  end

  def self.find_wallet_entries(ticker, current_user)
    Wallet.where(ticker: ticker, user_id: current_user)
  end

  def self.call_crypto_api_historical(ticker_symbol, timestamp, currency = 'EUR')
    # https://min-api.cryptocompare.com/documentation?key=Historical&cat=dataPriceHistorical
    # convert DateTime object to unixtime --> DateTime.new().to_time.to_i
    begin
      api_url = URI.parse("https://min-api.cryptocompare.com/data/pricehistorical?fsym=#{ticker_symbol}&tsyms=#{currency}&ts=#{timestamp.to_time.to_i}")
      p api_url
      response = Net::HTTP.get_response(api_url)
      p response
      json_response = JSON.parse(response.body)[ticker_symbol][currency]
      p json_response
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
