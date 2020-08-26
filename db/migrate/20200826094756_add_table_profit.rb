class AddTableProfit < ActiveRecord::Migration[6.0]
  def change
    create_table :profits do |t|
      t.string :ticker
      t.decimal :profit
      t.date :date
      t.decimal :total_profit

      t.timestamps
    end
  end
end
