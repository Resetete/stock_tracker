class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index] # allow visting this welcome page by not logged in users

  def index
  end
end
