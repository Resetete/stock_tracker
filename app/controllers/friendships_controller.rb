class FriendshipsController < ApplicationController

  def create
    friend = User.find(params[:friend])
    @friendship = Friendship.create(user: current_user, friend: friend)
    flash[:notice] = "Your friend #{friend.full_name} was sucessfully added"
    redirect_to my_friends_path
  end

  def destroy
    friend = current_user.friends.find(params[:id])
    friendship = Friendship.where(user_id: current_user, friend_id: friend).first
    friendship.destroy
    flash[:notice] = "You successfully removed #{friend.full_name}"
    redirect_to my_friends_path
  end

end
