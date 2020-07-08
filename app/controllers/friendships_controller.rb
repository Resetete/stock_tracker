class FriendshipsController < ApplicationController

  def create
    
  end

  def destroy
    friend = current_user.friends.find(params[:id])
    friendship = Friendship.where(user_id: current_user, friend_id: friend).first
    friendship.destroy
    flash[:notice] = "You successfully removed #{friend.full_name}"
    redirect_to my_friends_path
  end

end
