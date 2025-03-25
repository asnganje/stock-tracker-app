class UsersController < ApplicationController
  def my_portfolio
    # @stocks = current_user.stocks || []
    @stocks = current_user.stocks.to_a
  end
end
