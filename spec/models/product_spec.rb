require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#price' do
    it 'returns a float' do
      expect(Product.new(price_in_cents: 1234).price).to eq(12.34)
    end
  end
end
