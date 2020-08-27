class RemoveColumnTotalProfitFromProfits < ActiveRecord::Migration[6.0]
  def change
    remove_column :profits, :total_profit
  end
end
