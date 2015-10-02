require 'spec_helper'
require 'services/rate.rb'

describe Rate do
  let(:rate_uri_response) do
    {:Envelope=>
     {:"xmlns:gesmes"=>"http://www.gesmes.org/xml/2002-08-01",
      :xmlns=>"http://www.ecb.int/vocabulary/2002-08-01/eurofxref",
      :subject=>"Reference rates",
      :Sender=>{
        :name=>"European Central Bank"},
        :Cube=>{
          :Cube=>[{:time=>"2015-09-30",
                   :Cube=>[{:currency=>"USD", :rate=>"1.1203"},
                           {:currency=>"JPY", :rate=>"134.69"},
                           {:currency=>"GBP", :rate=>"0.7385"},
                           {:currency=>"HUF", :rate=>"313.45"},
                           {:currency=>"CAD", :rate=>"1.5034"},
                           {:currency=>"PHP", :rate=>"52.347"}]}]}}}
  end

  let(:currency)  { 'USD' }
  let(:rate)      { 1.1203 }

  context 'get the correct rate for currency' do
    subject do
      described_class.get_exchange_rates(currency)
    end

    before do
      expect(described_class).to receive(:get_rates_from_uri).and_return(rate_uri_response)
    end

    it { is_expected.to be rate }
  end
end
