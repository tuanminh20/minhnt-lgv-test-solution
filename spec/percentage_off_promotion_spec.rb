require_relative '../lib/percentage_off_promotion'
require_relative '../lib/checkout'

describe PercentageOffPromotion do
  it 'deducts 10% when it exceeds the eligibility of the rule' do
    chair1 = OrderItem.new('001', 'Very Cheap Chair', 925, 850)
    chair2 = OrderItem.new('001', 'Very Cheap Chair', 925, 850)
    table1 = OrderItem.new('002', 'Little table', 4500, 4500)
    discounted_chair = OrderItem.new('001', 'Very Cheap Chair', 925, 765)
    discounted_table = OrderItem.new('002', 'Little table', 4500, 4050)
    basket = [chair1, chair2, table1]
    promotional_rule = { type: 'percentage_off_basket', eligible_min_amount: 6000, percentage: 10 }

    percentage_off_promo = PercentageOffPromotion.new(promotional_rule, basket)

    expect(percentage_off_promo.discounted_basket).to eq [
      discounted_chair,
      discounted_chair,
      discounted_table,
    ]
  end

  it 'deducts 10% when it meets exactly the eligibility of the rule' do
    fake_item1 = OrderItem.new('001', 'Fake Item', 2000, 2000)
    fake_item2 = OrderItem.new('001', 'Fake Item', 2000, 2000)
    fake_item3 = OrderItem.new('001', 'Fake Item', 2000, 2000)
    discounted_fake_item = OrderItem.new('001', 'Fake Item', 2000, 1800.0)
    basket = [fake_item1, fake_item2, fake_item3]

    promotional_rule = {
      type: 'percentage_off_basket',
      eligible_min_amount: 6000,
      percentage: 10,
    }

    percentage_off_promo = PercentageOffPromotion.new(promotional_rule, basket)

    expect(percentage_off_promo.discounted_basket).to eq [
      discounted_fake_item,
      discounted_fake_item,
      discounted_fake_item,
    ]
  end

  it 'returns the original amount when it meets exactly the eligibility of the rule' do
    fake_item1 = OrderItem.new('001', 'Fake Item', 2000, 2000)
    fake_item2 = OrderItem.new('001', 'Fake Item', 2000, 2000)
    promotional_rule = {
      type: 'percentage_off_basket',
      eligible_min_amount: 6000,
      percentage: 10,
    }
    basket = [fake_item1, fake_item2]

    percentage_off_promo = PercentageOffPromotion.new(promotional_rule, basket)

    expect(percentage_off_promo.discounted_basket).to eq basket
  end
end
