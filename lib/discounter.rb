require_relative './multi_item_promotion'
require_relative './percentage_off_promotion'

class Discounter
  def initialize(
    promotional_rules: [],
    basket: [],
    percentage_off_promotion_klass: PercentageOffPromotion,
    multi_item_promotion_klass: MultiItemPromotion
  )
    @promotional_rules = promotional_rules
    @basket = basket
    @percentage_off_promotion_klass = percentage_off_promotion_klass
    @multi_item_promotion_klass = multi_item_promotion_klass
  end

  def apply
    current_total = total(@basket)
    prioritised_promo_rules.map do |promo_rule|
      if promo_rule[:type] == 'percentage_off_basket'
        current_total = @percentage_off_promotion_klass.new(promo_rule, current_total).apply
      end
      if promo_rule[:type] == 'multi_item'
        discounted_basket = @multi_item_promotion_klass.new(promo_rule, @basket).discounted_basket
        current_total = total(discounted_basket)
      end
    end
    current_total.round
  end

  private

  def total(basket)
    basket.inject(0) { |sum, item| sum + item[:discounted_price] }
  end

  def prioritised_promo_rules
    @promotional_rules.sort_by { |promo_rule| promo_rule[:priority] }
  end
end
