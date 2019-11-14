class Checkout
  def initialize
    @basket = []
  end

  def scan(item)
    @basket << item
  end

  def total
    number_to_currency(@basket.inject(0) { |sum, item| sum + item[:price] })
  end

  private

  def number_to_currency(price)
    format('£%.2f', (price / 100.00).round(2))
  end
end
