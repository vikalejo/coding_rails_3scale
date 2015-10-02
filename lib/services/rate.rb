require 'net/http'

# This module gets the exchange rates from the European Central Bank
class Rate
  RATE_URI = 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'
  CURRENCIES = %w(USD PHP GBP)

  # Get the exchange rates from ecb.europa url
  # Convert the xml response in a hash
  def self.get_exchange_rates(currency)
    hash_rates = get_rates_from_uri

    # The first value content the updatest rates
    hash_cubes = hash_rates[:Envelope][:Cube][:Cube].first
    # Gets the Cube of rates
    rates = hash_cubes[:Cube]

    cache_rates_for_currencies(rates) if $redis.get(currency).to_f
    rate = $redis.get(currency).to_f
  end

  def self.default_currency
    'EUR'
  end

  private

  def self.get_rates_from_uri
    Hash.from_xml(Net::HTTP.get(URI RATE_URI)).deep_symbolize_keys
  end

  def self.cache_rates_for_currencies(rates)
    rates.map do |h|
      CURRENCIES.find_all do |c|
        $redis.set("#{c}", h[:rate]) if c == h[:currency]
        $redis.expire("#{c}", 1.minute.to_i)
      end
    end
  end
end

