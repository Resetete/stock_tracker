class AddUserIdToProfits < ActiveRecord::Migration[6.0]
  def change
    add_column :profits, :user_id, :int
  end
end
