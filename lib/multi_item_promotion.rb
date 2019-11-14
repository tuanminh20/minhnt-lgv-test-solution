class MultiItemPromotion
  def initialize(promo_rule, basket)
    @promo_rule = promo_rule
    @basket = basket
  end

  def apply
    if eligibile?
      return basket_total - calculate_discount
    end
    basket_total
  end

  private

  def eligibile?
    eligible_items_count >= @promo_rule[:eligible_min_quantity]
  end

  def eligible_items_count
    @basket.count do |item|
      item[:code] == @promo_rule[:item_code]
    end
  end

  def calculate_discount
    eligible_items_count * (eligible_item_price - @promo_rule[:reduced_price])
  end

  def eligible_item_price
    @basket.find { |item| item[:code] == @promo_rule[:item_code] }[:price]
  end

  def basket_total
    @basket.inject(0) { |sum, item| sum + item[:price] }
  end
end
