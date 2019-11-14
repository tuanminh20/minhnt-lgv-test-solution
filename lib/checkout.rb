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
      if promo_rule[:type] == 'multi_item'
        gross_total = multi_item_promotion(promo_rule)
      end
    end
    number_to_currency(gross_total)
  end

  private

  def multi_item_promotion(promo_rule)
    if multi_item_promotion_eligibile?(promo_rule)
      return net_total - multi_item_calculate_discount(promo_rule)
    end
    net_total
  end

  def multi_item_promotion_eligibile?(promo_rule)
    multi_item_promotion_eligible_items_count(promo_rule) >= promo_rule[:eligible_min_quantity]
  end

  def multi_item_promotion_eligible_items_count(promo_rule)
    @basket.count do |item|
      item[:code] == promo_rule[:item_code]
    end
  end

  def multi_item_calculate_discount(promo_rule)
    multi_item_promotion_eligible_items_count(promo_rule) * (multi_item_promotion_eligible_item_price(promo_rule) - promo_rule[:reduced_price])
  end

  def multi_item_promotion_eligible_item_price(promo_rule)
    @basket.find { |item| item[:code] == promo_rule[:item_code] }[:price]
  end

  def net_total
    @basket.inject(0) { |sum, item| sum + item[:price] }
  end

  def number_to_currency(price)
    format('£%.2f', (price / 100.00).round(2))
  end
end
