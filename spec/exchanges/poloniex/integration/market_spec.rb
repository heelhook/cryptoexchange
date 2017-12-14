require 'spec_helper'

RSpec.describe 'Poloniex integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:ltc_btc_pair) { Cryptoexchange::Models::MarketPair.new(base: 'LTC', target: 'BTC', market: 'poloniex') }
  let(:btc_bcn_pair) { Cryptoexchange::Models::MarketPair.new(base: 'BTC', target: 'BCN', market: 'poloniex') }

  it 'fetch pairs' do
    pairs = client.pairs('poloniex')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'poloniex'
  end

  it 'fetch pairs and assign the correct base/target' do
    pairs = client.pairs('poloniex')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to eq 'BCN'
    expect(pair.target).to eq 'BTC'
    expect(pair.market).to eq 'poloniex'
  end

  it 'fetch ticker' do
    ticker = client.ticker(ltc_btc_pair)

    expect(ticker.base).to eq 'LTC'
    expect(ticker.target).to eq 'BTC'
    expect(ticker.market).to eq 'poloniex'
    expect(ticker.last).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be_a Numeric
    expect(2000..Date.today.year).to include(Time.at(ticker.timestamp).year)
    expect(ticker.payload).to_not be nil
  end

  it 'fetch order book' do
    order_book = client.order_book(btc_bcn_pair)
    expect(order_book.base).to eq 'BTC'
    expect(order_book.target).to eq 'BCN'
    expect(order_book.market).to eq 'poloniex'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to_not be_nil
    expect(order_book.timestamp).to be_a Numeric
    expect(order_book.payload).to_not be nil
  end
end
