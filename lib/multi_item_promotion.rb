class MultiItemPromotion
  def initialize(promo_rule, basket)
    @promo_rule = promo_rule
    @basket = basket
  end

  def discounted_basket
    if eligibile?
      return discount_items
    end
    @basket
  end

  private

  def eligibile?
    eligible_items_count >= @promo_rule[:eligible_min_quantity]
  end

  def eligible_items_count
    @basket.count do |item|
      item[:item_code] == @promo_rule[:item_code]
    end
  end

  def discount_items
    @basket.map {|item|
      item[:discounted_price] = @promo_rule[:discounted_price] if item[:item_code] == @promo_rule[:item_code] 
      item
    }
  end
end
