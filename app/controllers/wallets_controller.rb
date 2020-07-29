class WalletsController < ApplicationController
  before_action :set_wallet_entry, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:show]
  before_action :get_ticker_options, only: [:new, :edit]

  def index
  end

  def show
  end

  def edit
  end

  def update
    set_current_profit
    if @wallet.update(wallet_params)
      flash[:notice] = 'Wallet entry was successfully updated'
      redirect_to my_profit_path
    else
      render 'edit'
    end
  end

  def new
    @wallet = Wallet.new
  end

  def create
    @wallet = Wallet.new(wallet_params)
    set_current_profit
    @wallet.user = current_user
    if @wallet.save
      flash[:notice] = "Wallet entry successfully created"
      redirect_to @wallet
    else
      flash[:alert] = "Something went wrong"
      render 'new'
    end
  end

  private

  def wallet_params
    params.require(:wallet).permit(:ticker, :name, :buy_date, :buy_price, :trading_fee, :selling_fee, :amount_bought)
  end

  def set_wallet_entry
    @wallet = Wallet.find(params[:id])
  end

  def require_same_user
    if current_user != @wallet.user
      flash[:alert] = 'You can only view wallet entries that you own.'
      redirect_to root_path
    end
  end

  def get_ticker_options
    @ticker_options = Wallet.get_ticker_options
  end

  def set_current_profit
    @wallet.current_profit = @wallet.calc_current_profit(@wallet.ticker, @wallet.amount_bought, @wallet.buy_price)
  end
end
