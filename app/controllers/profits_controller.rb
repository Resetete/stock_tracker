class ProfitsController < ApplicationController

  def update_daily_profit
    Profit.daily_profit(current_user)
    p "current user #{current_user.id}"
    @graph_data = Profit.where(user_id: current_user)
    redirect_to my_profit_path + '#profit-graph'
  end

end
