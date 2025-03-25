class UsersController < ApplicationController
  def my_portfolio
    # @stocks = current_user.stocks || []
    @stocks = current_user.stocks.to_a
  end

  def my_friends
    @friends = current_user.friends
  end

  def search
    if params[:friend].present?
      @friend = params[:friend]
      if @friend
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("friend-results", partial: "users/friend_result", locals: { friend: @friend })
            end
            format.html do
              render "users/my_friends"
              end
        end
      else
        flash[:alert] = "Please enter a valid stock symbol!"
        redirect_to my_friends_path
        end   
    else
      flash[:alert] = "Please enter a name or email!"
        redirect_to my_friends_path
    end
  end
end
