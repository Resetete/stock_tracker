class Profit < ApplicationRecord

  def self.daily_profit
    Wallet.distinct.pluck(:ticker).each do |ticker|
      Wallet.where(buy_date: start_date..end_date && ticker == ticker).each_with_index do |wallet_entry, index|
        # calculate for each entry and for a first empty bought_on date until today the total profit --> store in profits table
        # for each of those wallet_entries calculate the profit for
        profit = wallet_entry.calc_current_profit(wallet_entry.ticker, wallet_entry.amount_bought, wallet_entry.buy_price)
        begin
          create(ticker: wallet_entry.ticker, profit: profit, date: start_date+index)
        rescue
          flash[:alert] = "Something went wrong calculating the profits"
        end
      end
    end
    #@wallet.calc_current_profit(@wallet.ticker, @wallet.amount_bought, @wallet.buy_price)
    #last_price = Stock.new_crypto_lookup(@wallet.ticker, @wallet.currency).last_price
    #Profit.update(current_profit: updated_profit, last_price: last_price)
  end

  def self.test # fill_the_profit table
    tickers.each do |ticker|
      find_wallet_entries(ticker).each do |wallet_entry|
        date_range.each do |date|
          #profit = wallet_entry.calc_current_profit(wallet_entry.ticker, wallet_entry.amount_bought, wallet_entry.buy_price) # needs to be passed the date for calculation!! If not the current course is used
          profit = 9999
          Profit.create(ticker: wallet_entry.ticker, profit: profit, date: date)
        end
      end
    end
  end

  def self.test2
    call_crypto_api_historical('BTC', 'DateTime.new(2020, 1, 1, 10,10,10)')
  end

  def daily_total_profit
  end

  private

  def self.start_date
    DateTime.new(2020, 8, 1, 10, 10, 10) # should be the first bought_on where total profit in profits table is empty
  end

  def self.end_date
    DateTime.current
  end

  def self.tickers
    Wallet.distinct.pluck(:ticker)
  end

  def self.date_range
    start_date..end_date
  end

  def self.find_wallet_entries(ticker)
    Wallet.where(ticker: ticker)
  end

  def self.call_crypto_api_historical(ticker_symbol, timestamp, currency = 'EUR')
    # https://min-api.cryptocompare.com/documentation?key=Historical&cat=dataPriceHistorical
    # convert DateTime object to unixtime --> DateTime.new().to_time.to_i
    api_url = URI.parse("https://min-api.cryptocompare.com/data/pricehistorical?fsym=#{ticker_symbol}&tsyms=#{currency}&ts=#{timestamp.to_time.to_i}")
    response = Net::HTTP.get_response(api_url)
    json_response = JSON.parse(response.body)[ticker_symbol][currency]
  end



end
