require 'pry'
require_relative './percentage_off_promotion'

class Checkout
  def initialize(promotional_rules: [], percentage_off_promotion_klass: PercentageOffPromotion)
    @percentage_off_promotion_klass = percentage_off_promotion_klass
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
        gross_total = @percentage_off_promotion_klass.new(promo_rule, net_total).apply
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
end
