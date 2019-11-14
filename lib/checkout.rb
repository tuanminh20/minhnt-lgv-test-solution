require 'pry'

class Checkout
  def initialize(promotional_rules: [])
    @promotional_rules = promotional_rules
    @basket = []
  end

  def scan(item)
    @basket << item
  end

  def total
    gross_total = net_total
    @promotional_rules.map do |promo_rule|
      if promo_rule[:type] == 'percentage_off_basket'
        gross_total = apply_percentage_off_promotion(promo_rule)
      end
    end
    number_to_currency(gross_total)
  end

  private

  def net_total
    @basket.inject(0) { |sum, item| sum + item[:price] }
  end

  def number_to_currency(price)
    format('£%.2f', (price / 100.00).round(2))
  end

  def apply_percentage_off_promotion(promo_rule)
    if percentage_off_promotion_eligible?(promo_rule)
      return net_total - percentage_off_promotion_discount(promo_rule)
    end
    net_total
  end

  def percentage_off_promotion_discount(promo_rule)
    net_total / 100.0 * promo_rule[:percentage]
  end

  def percentage_off_promotion_eligible?(promo_rule)
    net_total >= promo_rule[:eligible_amount]
  end
end
