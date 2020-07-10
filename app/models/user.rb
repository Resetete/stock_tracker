class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_save :capitalize_names

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

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  def friend_already_tracked?(friends_first_name, friends_last_name)
    search_result = check_db(friends_first_name, friends_last_name) # check if the friend exists in db
    return false unless search_result # if it doesn't exist return false
    evaluation = search_result.to_a.map do |result|
      friends.where(id: result.id).exists? # check if this friend is tracked by the user (see friendships table)
    end
    evaluation.any? # check if there is any true in the results array
  end

  def can_track_friend?(friends_first_name, friends_last_name)
    !friend_already_tracked?(friends_first_name, friends_last_name)
  end

  def check_db(first_name, last_name)
    User.where(first_name: first_name, last_name: last_name)
  end

  def self.search(friend_first_name, friend_name_email)
    # remove any extra characters such as spaces
    friend_first_name.strip!
    friend_name_email.strip!
    # need to check if the param matches any of our fields data
    to_send_back = (first_name_matches(friend_first_name) + last_name_matches(friend_name_email) + email_matches(friend_name_email)).uniq
    return nil unless to_send_back
    to_send_back
  end

  def self.first_name_matches(param)
    return [] unless !param.empty?
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    return [] unless !param.empty?
    matches('last_name', param)
  end

  def self.email_matches(param)
    return [] unless !param.empty?
    matches('email', param)
  end

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

  private

  def capitalize_names
    first_name.capitalize!
    last_name.capitalize!
  end

end
