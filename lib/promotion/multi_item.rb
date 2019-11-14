# frozen_string_literal: true

require_relative './base'

module Promotion
  class MultiItem < Promotion::Base
    private

    def eligible?(basket)
      eligible_items_count(basket) >= @promo_rule[:eligible_min_quantity]
    end

    def eligible_items_count(basket)
      basket.count do |item|
        eligible_item?(item)
      end
    end

    def discount_items(basket)
      basket.map do |item|
        item[:discounted_price] = @promo_rule[:discounted_price] if eligible_item?(item)
        item
      end
    end

    def eligible_item?(item)
      item[:item_code] == @promo_rule[:item_code]
    end
  end
end
