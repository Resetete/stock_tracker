class FriendsController < ApplicationController
  def search
    if params[:friend].present?
      @friend = User.where(first_name: params[:friend]) # .first
      if @friend
        respond_to do |format|
          format.js { render partial: 'users/friends_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "We couldn't find your friend. Please enter an existing fiends name"
          format.js { render partial: 'users/friends_result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter the name of your friend to search"
        format.js { render partial: 'users/friends_result' }
      end
    end
  end
end
