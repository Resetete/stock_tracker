class ProfitsController < ApplicationController

  def update_daily_profit
    @graph_data = Profit.where(user_id: current_user)

    redirect_to my_profit_path + '#profit-graph'
  end

end
