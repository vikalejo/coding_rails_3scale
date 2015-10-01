class Product < ActiveRecord::Base
  attr_accessor :currency
  attr_accessor :price

  def price
    price_in_cents / 100.0
  end

  # Use the currency selected to return the products
  # using the correct rate
  # It does not modify the ddbb value
  def self.all_by_currency(rate = nil, currency)
    rate = 1 if currency == Rate.default_currency
    rate ||= Rate.get_exchange_rates(currency)

    Product.all.map do |product|
      attributes = product.attributes
      attributes['price_in_cents'] = attributes['price_in_cents'] * rate

      Product.new(attributes).tap do |p|
        p.currency = currency
      end
    end
  end

  # Using the currency selected, returns the product with
  # the correct rate in the product description
  def self.find_by(params)
    product = Product.where(id: params['id']).first
    attributes = product.attributes

    Product.new(attributes).tap do |p|
      p.price = params['price'].to_i
      p.currency = params['currency']
    end
  end
end
