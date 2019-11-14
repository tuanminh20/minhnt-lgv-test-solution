class MultiItemPromotion
  def initialize(promo_rule, basket)
    @promo_rule = promo_rule
    @basket = basket
  end

  def discounted_basket
    eligibile? ? discount_items : @basket
  end

  private

  def eligibile?
    eligible_items_count >= @promo_rule[:eligible_min_quantity]
  end

  def eligible_items_count
    @basket.count do |item|
      eligible_item?(item)
    end
  end

  def discount_items
    @basket.map do |item|
      item[:discounted_price] = @promo_rule[:discounted_price] if eligible_item?(item)
      item
    end
  end

  def eligible_item?(item)
    item[:item_code] == @promo_rule[:item_code]
  end
end
