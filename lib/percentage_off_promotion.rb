class PercentageOffPromotion
  def initialize(rule, amount)
    @rule = rule
    @amount = amount
  end

  def apply
    if eligible?
      return @amount - discount
    end
    @amount
  end

  private

  def discount
    @amount / 100.0 * @rule[:percentage]
  end

  def eligible?
    @amount >= @rule[:eligible_amount]
  end
end
