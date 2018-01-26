module Cryptoexchange
  module Models
    class MarketPair
      attr_accessor :base, :target, :market, :exchange_id

      def initialize(params={})
        @base = params[:base]
        @target = params[:target]
        @market = params[:market]
        @exchange_id = params[:exchange_id]
      end

      def target
        @target.to_s.upcase
      end

      def base
        @base.to_s.upcase
      end
    end
  end
end
