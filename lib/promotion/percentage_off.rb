# frozen_string_literal: true

require_relative './base'

module Promotion
  class PercentageOff < Promotion::Base
    private

    def eligible?(basket)
      total(basket) >= @promo_rule[:eligible_min_amount]
    end

    def discount_items(basket)
      basket.map do |item|
        item[:discounted_price] -= discount_to_be_applied(item[:discounted_price])
        item
      end
    end

    def discount_to_be_applied(amount)
      amount / 100.0 * @promo_rule[:percentage]
    end

    def total(basket)
      basket.inject(0) { |sum, item| sum + item[:discounted_price] }
    end
  end
end
