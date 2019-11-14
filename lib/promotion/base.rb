# frozen_string_literal: true

module Promotion
  class Base
    attr_reader :promo_rule

    def initialize(**promo_rule)
      @promo_rule = promo_rule
    end

    def discounted_basket(basket)
      eligible?(basket) ? discount_items(basket) : basket
    end

    private

    def eligible?(_basket)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def discount_items(_basket)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end
end
