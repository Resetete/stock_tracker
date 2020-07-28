class WalletsController < ApplicationController

  def index
  end

  def new
    @wallet = Wallet.new
    @ticker_options = Wallet.get_ticker_options
    #byebug
  end
end
