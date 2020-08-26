class ProfitsController < ApplicationController
  def update_daily_profit
    @test = 'test'
    @graph_data = Profit.daily_total_profit  
    respond_to do |format|
      format.js { render partial: 'profits/update_daily_profit_result' }
    end
  end


end
