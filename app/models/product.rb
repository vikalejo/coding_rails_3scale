class Product < ActiveRecord::Base

  def price
    price_in_cents / 100.0
  end
end
