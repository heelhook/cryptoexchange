require 'spec_helper'

RSpec.describe 'Gatecoin integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:btc_hkd_pair) { Cryptoexchange::Models::MarketPair.new(base: 'BTC', target: 'HKD', market: 'gatecoin') }
  let(:btc_eur_pair) { Cryptoexchange::Models::MarketPair.new(base: 'BTC', target: 'EUR', market: 'gatecoin') }

  it 'fetch pairs' do
    pairs = client.pairs('gatecoin')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'gatecoin'
  end

  it 'fetch ticker' do
    ticker = client.ticker(btc_hkd_pair)

    expect(ticker.base).to eq 'BTC'
    expect(ticker.target).to eq 'HKD'
    expect(ticker.market).to eq 'gatecoin'
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
    order_book = client.order_book(btc_eur_pair)
    expect(order_book.base).to eq 'BTC'
    expect(order_book.target).to eq 'EUR'
    expect(order_book.market).to eq 'gatecoin'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to_not be_nil
    expect(order_book.timestamp).to be_a Numeric
    expect(order_book.payload).to_not be nil
  end
end
