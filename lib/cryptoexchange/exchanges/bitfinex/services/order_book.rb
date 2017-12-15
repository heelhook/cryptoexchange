module Cryptoexchange::Exchanges
  module Bitfinex
    module Services
      class OrderBook < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            true
          end
        end

        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output, market_pair)
        end

        def ticker_url(market_pair)
          base = market_pair.base
          target = market_pair.target
          "#{Cryptoexchange::Exchanges::Bitfinex::Market::API_URL}/book/#{base}#{target}"
        end

        def adapt(output, market_pair)
          order_book = Cryptoexchange::Models::OrderBook.new

          output = output

          order_book.base = market_pair.base
          order_book.target = market_pair.target
          order_book.market = Bitfinex::Market::NAME
          order_book.asks = adapt_orders output['asks']
          order_book.bids = adapt_orders output['bids']
          order_book.timestamp = Time.now.to_i
          order_book.payload = output
          order_book
        end

        def adapt_orders(orders)
          orders.collect do |order_entry|
            Cryptoexchange::Models::Order.new(price: order_entry['price'].to_f,
                                              amount: order_entry['amount'].to_f,
                                              timestamp: Time.now.to_i)
          end
        end
      end
    end
  end
end
