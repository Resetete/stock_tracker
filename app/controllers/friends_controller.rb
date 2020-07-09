class FriendsController < ApplicationController
  def search
    if params[:friend_first_name].present? || params[:friend_last_name].present?
      @friend = User.find_friend(params[:friend_first_name], params[:friend_last_name])
      if @friend.any?
        respond_to do |format|
          format.js { render partial: 'users/friends_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "We couldn't find your friend. Please enter an existing friends name"
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
