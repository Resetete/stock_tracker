class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @tracked_friends = current_user.friends
  end

  def my_profit
    @user = current_user
    @wallets = current_user.wallets
    @total_profit = @wallets.sum(:current_profit)
    if current_user.first_name == 'Max' && current_user.last_name == 'Mustermann'
      flash.now[:alert] = "Only for testing purposes. Do not enter your real values!"
    end
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end
end
