class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])  
      if @stock
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("stock_results", partial: "users/results", locals: { stock: @stock })
          end
          format.html { redirect_to my_portfolio_path(stock: params[:stock]) }
        end
      else
        flash[:alert] = "Please enter a valid stock symbol!"
        redirect_to my_portfolio_path
      end
      else
        flash[:alert] = "Please enter a stock symbol!"
        redirect_to my_portfolio_path
      end
    end
  end
