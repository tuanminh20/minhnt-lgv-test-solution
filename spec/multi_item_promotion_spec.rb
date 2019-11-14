require_relative '../lib/multi_item_promotion'
require_relative '../lib/checkout'

describe MultiItemPromotion do
  it 'returns discounted basket when it has more than x associated items' do
    chair1 = OrderItem.new('001', 'Very Cheap Chair', 925, 925)
    chair2 = OrderItem.new('001', 'Very Cheap Chair', 925, 925)
    discounted_chair = OrderItem.new('001', 'Very Cheap Chair', 925, 850)
    promotional_rule = {
      type: 'multi_item',
      eligible_min_quantity: 2,
      item_code: '001',
      discounted_price: 850,
    }
    basket = [chair1, chair2]

    multi_item_promo = MultiItemPromotion.new(promotional_rule, basket)

    expect(multi_item_promo.discounted_basket).to eq [discounted_chair, discounted_chair]
  end

  it 'returns discounted basket when it has more than x associated items and other items' do
    chair1 = OrderItem.new('001', 'Very Cheap Chair', 925, 925)
    chair2 = OrderItem.new('001', 'Very Cheap Chair', 925, 925)
    table1 = OrderItem.new('002', 'Little table', 4500, 4500)
    discounted_chair = OrderItem.new('001', 'Very Cheap Chair', 925, 850)
    promotional_rule = {
      type: 'multi_item',
      eligible_min_quantity: 2,
      item_code: '001',
      discounted_price: 850,
    }
    basket = [chair1, chair2, table1]

    multi_item_promo = MultiItemPromotion.new(promotional_rule, basket)

    expect(multi_item_promo.discounted_basket).to eq [discounted_chair, discounted_chair, table1]
  end

  it 'returns the original basket when it is not eligible' do
    chair1 = OrderItem.new('001', 'Very Cheap Chair', 925, 925)
    table1 = OrderItem.new('002', 'Little table', 4500, 4500)
    promotional_rule = {
      type: 'multi_item',
      eligible_min_quantity: 2,
      item_code: '001',
      discounted_price: 850,
    }
    basket = [chair1, table1]

    multi_item_promo = MultiItemPromotion.new(promotional_rule, basket)

    expect(multi_item_promo.discounted_basket).to eq basket
  end
end
