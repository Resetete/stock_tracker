class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol) # check if the stock already exists in db
    return false unless stock # if it doesn't exist return false
    stocks.where(id: stock.id).exists? # if the stock exists check if the stock is tracked by the user
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def under_friend_limit?
    friends.count < 10
  end

  def self_tracking?(current_user_full_name, friends_full_name) # check if the current_user is adding themself
    current_user_full_name == friends_full_name
  end

  def friend_already_tracked?(friends_first_name, friends_last_name)
    search_result = check_db(friends_first_name, friends_last_name) # check if the friend exists in db
    return false unless search_result # if it doesn't exist return false
    evaluation = search_result.to_a.map do |result|
      friends.where(id: result.id).exists? # check if this friend is tracked by the user (see friendships table)
    end
    evaluation.any? # check if there is any true in the results array
  end

  def can_track_friend?(friends_first_name, friends_last_name, current_user_full_name, friends_full_name)
    under_friend_limit? && !friend_already_tracked?(friends_first_name, friends_last_name) && !self_tracking?(current_user_full_name, friends_full_name)
  end

  def check_db(first_name, last_name)
    User.where(first_name: first_name, last_name: last_name)
  end

  def self.find_friend(friend_first_name, friend_last_name)
    if !friend_first_name.empty? && !friend_last_name.empty?
      where(first_name: friend_first_name, last_name: friend_last_name)
    elsif friend_last_name.empty? && !friend_first_name.empty?
      where(first_name: friend_first_name)
    elsif friend_first_name.empty? && !friend_last_name.empty?
      where(last_name: friend_last_name)
    else
      nil
    end
  end
end
