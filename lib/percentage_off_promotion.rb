class PercentageOffPromotion
  def initialize(promo_rule, basket)
    @promo_rule = promo_rule
    @basket = basket
  end

  def discounted_basket
    eligible? ? discount_items : @basket
  end

  private

  def eligible?
    total >= @promo_rule[:eligible_min_amount]
  end

  def discount_items
    @basket.map do |item|
      item[:discounted_price] -= discount_to_be_applied(item[:discounted_price])
      item
    end
  end

  def discount_to_be_applied(amount)
    amount / 100.0 * @promo_rule[:percentage]
  end

  def total
    @basket.inject(0) { |sum, item| sum + item[:discounted_price] }
  end
end
