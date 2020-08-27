class ProfitsController < ApplicationController

  def update_daily_profit
    @graph_data = Profit.where(user_id: current_user)
    Profit.daily_profit
    redirect_to my_profit_path + '#profit-graph'
  end

end
