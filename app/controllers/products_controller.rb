class ProductsController < ApplicationController
  # Show the ddbb price fixed for the product in EUR
  # Use the rate exchange to show the price in other currency
  def index
    currency = params[:currency] || Rate.default_currency
    cookies[:currency] = currency
    @products = Product.all_by_currency(currency)
  end

  def show
    @product = Product.find_by(params)
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price_in_cents)
  end
end
