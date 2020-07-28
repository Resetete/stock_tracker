class Wallet < ApplicationRecord
  belongs_to :user

  def self.get_ticker_options
    %w[ETH BTCEUR].freeze
  end
end
