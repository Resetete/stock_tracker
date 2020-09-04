class ProfitsController < ApplicationController
  def update_daily_profit
    @msg = Profit.daily_profit(current_user)
    @graph_data = Profit.where(user_id: current_user)
    flash[:notice] = 'Graph is already up to date' if @msg
    redirect_to my_profit_path + '#profit-graph'
  end
end
