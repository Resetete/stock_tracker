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
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end
end
