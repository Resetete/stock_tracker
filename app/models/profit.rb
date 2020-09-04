class Profit < ApplicationRecord
  belongs_to :user

  def self.daily_profit(current_user)
    @msg = ['Already up to date:']
    tickers.each do |ticker|
      find_wallet_entries(ticker, current_user).each do |wallet_entry|
        date_range(wallet_entry).each do |date|
          if !already_fetched?(date, ticker, current_user)
            profit = calc_profit(wallet_entry.ticker, date, wallet_entry.amount_bought, wallet_entry.buy_price, wallet_entry.trading_fee, wallet_entry.selling_fee)
            Profit.create(ticker: wallet_entry.ticker, profit: profit, date: date, user_id: wallet_entry.user_id)
          else
            @msg.push("#{wallet_entry.ticker}, #{date}")
          end
        end
      end
    end
    return @msg
  end

  private

  def self.start_date(wallet_entry)
    #DateTime.new(2020, 8, 28, 0, 0, 0)
    Wallet.find(wallet_entry.id).buy_date.to_date + 1.day
  end

  def self.end_date
    #DateTime.new(2020, 9, 2, 0, 0, 0)
    DateTime.yesterday
  end

  def self.already_fetched?(date, ticker, current_user) # checks if the profit for a ticker was already calculated
    if Profit.where(user_id: current_user, ticker: ticker).empty?
      false
    elsif Profit.where(user_id: current_user, ticker: ticker).order(date: :desc).first.date >= date
      true
    end
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
    max_retries = 3
    times_retried = 0
    begin
      api_url = URI.parse("https://min-api.cryptocompare.com/data/pricehistorical?fsym=#{ticker_symbol}&tsyms=#{currency}&ts=#{timestamp.to_time.to_i}")
      response = Net::HTTP.get_response(api_url)
      json_response = JSON.parse(response.body)[ticker_symbol][currency]
    rescue => e
      if times_retried < max_retries
        times_retried += 1
        puts "Error occured: #{e}; retry #{times_retried}/#{max_retries}"
        retry
      else
        puts 'Exiting script; it is unlikely to solve the error of catching data'
        nil
      end
    end
  end

  def self.calc_profit(ticker, date, amount_bought, buy_price, trading_fee, selling_fee)
    if call_crypto_api_historical(ticker, date).nil?
      nil
    else
      begin
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
      rescue => e
        p "Error when calculating profit #{e}"
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
