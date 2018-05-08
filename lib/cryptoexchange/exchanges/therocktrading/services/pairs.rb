module Cryptoexchange::Exchanges
  module Therocktrading
    module Services
      class Pairs < Cryptoexchange::Services::Pairs
        PAIRS_URL = "#{Cryptoexchange::Exchanges::Therocktrading::Market::API_URL}/funds/tickers"

        def fetch
          output = super
          adapt(output)
        end

        def adapt(output)
          market_pairs = []
          tickers = output['tickers']
          tickers.each do |pair|
            base, target = pair['fund_id'][0,3], pair['fund_id'][3..-1]
            market_pairs << Cryptoexchange::Models::MarketPair.new(
                              base: base,
                              target: target,
                              market: Therocktrading::Market::NAME
                            )
          end
          market_pairs
        end
      end
    end
  end
end
