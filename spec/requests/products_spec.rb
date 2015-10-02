require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /products" do
    before do
      3.times { create(:product) }
    end

    it "lists all products" do
      get products_path
      expect(response).to have_http_status(200)
      products = Nokogiri::HTML(response.body).css('.product')
      expect(products.length).to eq(3)
    end
  end

  describe "GET /products" do
    let(:price_in_cents) { 3456 }

    before do
      @product = create(:product, price_in_cents: price_in_cents)
    end

    it "shows product details" do
      get product_path(@product, :currency => 'EUR', :price => price_in_cents / 100.0)
      expect(response).to have_http_status(200)
      price = Nokogiri::HTML(response.body).css('.product strong')
      expect(price.text).to match(/34.56\sEUR/)
    end
  end
end
