class UserStocksController < ApplicationController
  def create
    stock = Stock.check_db(params[:ticker])
    # puts "Stock checked: #{stock.inspect}" 
    if stock.blank?
      stock = Stock.new_lookup(params[:ticker])
      stock.save!
      @user_stock = UserStock.create!(user:current_user, stock:stock)
      flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio!"
      redirect_to my_portfolio_path
    end
  end
end
