require_relative './discounter'
require_relative './order_item'

class Checkout
  def initialize(promotional_rules: [], discounter: Discounter)
    @discounter = discounter
    @promotional_rules = promotional_rules
    @basket = []
  end

  def scan(item)
    @basket << OrderItem.new(item[:code], item[:name], item[:price], item[:price])
  end

  def total
    @basket = @discounter.new(
      promotional_rules: @promotional_rules,
      basket: @basket
    ).discounted_basket
    number_to_currency(total_price)
  end

  private

  def total_price
    @basket.inject(0) { |sum, item| sum + item[:discounted_price] }
  end

  def number_to_currency(price)
    format('£%.2f', (price / 100.00).round(2))
  end
end
