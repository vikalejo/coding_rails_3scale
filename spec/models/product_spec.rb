require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#price' do
    it 'returns a float' do
      expect(Product.new(price_in_cents: 1234).price).to eq(12.34)
    end
  end

  describe '#all_by_currency' do
    let(:currency) { 'EUR' }

    subject do
      described_class.all_by_currency(currency)
    end

    context 'with default currency' do
      let(:rate) { 1 }

      before do
        3.times { create(:product) }
      end

      it 'not change the price attribute of the products' do
        Product.all.each do |product|
          expect { subject }.to_not change(product, :price_in_cents)
        end
      end
    end

    context 'with a different currency' do
      let(:currency) { 'USD' }
      let(:rate) { 2 }

      before do
        3.times { create(:product) }
        allow(Rate).to receive(:get_exchange_rates).and_return(rate)
      end

      it 'not change the attribute price of the products' do
        Product.all.each do |product|
          expect { subject }.to_not change(product, :price_in_cents)
        end
      end

      it 'shows the currency selected' do
        subject.each do |product|
          expect(product.currency).to match 'USD'
        end
      end

      it 'shows the price corresponding the rate' do
        subject.each do |product|
          expect(product.price_in_cents)
            .to be Product.first.price_in_cents * 2
        end
      end
    end
  end
end
