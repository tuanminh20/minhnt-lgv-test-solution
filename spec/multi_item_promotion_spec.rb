require_relative '../lib/multi_item_promotion'
require_relative '../lib/item'

describe MultiItemPromotion do
  it 'returns the discounted amount when it has more than x associated items' do
    item1 = Item.new('001', 'Very Cheap Chair', 925)
    promotional_rule = {
      type: 'multi_item',
      eligible_min_quantity: 2,
      item_code: '001',
      reduced_price: 850,
    }
    basket = [item1, item1]

    multi_item_promo = MultiItemPromotion.new(promotional_rule, basket)

    expect(multi_item_promo.apply).to eq 1700
  end

  it 'returns the discounted amount when it has more than x associated items and other items' do
    item1 = Item.new('001', 'Very Cheap Chair', 925)
    item2 = Item.new('002', 'Little table', 4500)
    promotional_rule = {
      type: 'multi_item',
      eligible_min_quantity: 2,
      item_code: '001',
      reduced_price: 850,
    }
    basket = [item1, item1, item2]

    multi_item_promo = MultiItemPromotion.new(promotional_rule, basket)

    expect(multi_item_promo.apply).to eq 6200
  end

  it 'returns the standard amount when it is not eligible' do
    item1 = Item.new('001', 'Very Cheap Chair', 925)
    item2 = Item.new('002', 'Little table', 4500)
    promotional_rule = {
      type: 'multi_item',
      eligible_min_quantity: 2,
      item_code: '001',
      reduced_price: 850,
    }
    basket = [item1, item2]

    multi_item_promo = MultiItemPromotion.new(promotional_rule, basket)

    expect(multi_item_promo.apply).to eq 5425
  end
end
