# CHECKOUT SYSTEM

Our client is an online marketplace; here is a sample of some of the products available on the site:

```
Product code  | Name                   | Price
----------------------------------------------------------
001           | Lavender heart         | £9.25
002           | Personalised cufflinks | £45.00
003           | Kids T-shirt           | £19.95
```

This is just an example of products, your system should be ready to accept any kind of product.

Our marketing team wants to offer promotions as an incentive for our customers to purchase these items.

If you spend over £60, then you get 10% off of your purchase. If you buy 2 or more lavender hearts then the price drops to £8.50.

Our check-out can scan items in any order, and because our promotions will change, it needs to be flexible regarding our promotional rules.

The interface to our checkout looks like this (shown in Ruby):

```ruby
co = Checkout.new(promotional_rules)
co.scan(item)
co.scan(item)
price = co.total
```

Your task is to implement a checkout system that fulfils these requirements. Please do this outside of any frameworks, as we are looking for you to demonstrate your knowledge of TDD.

```
Test data
---------
Basket: 001,002,003
Total price expected: £66.78
Basket: 001,003,001
Total price expected: £36.95
Basket: 001,002,001,003
Total price expected: £73.76
```

## HOW TO RUN

- Create promotions

```ruby
promotion1 = Promotion::PercentageOff.new(
  type: :percentage_off,
  eligible_min_amount: 6000,
  percentage: 10,
  priority: 1
)

promotion2 = Promotion::MultiItem.new(
  type: :multi_item,
  eligible_min_quantity: 2,
  item_code: '001',
  discounted_price: 850,
  priority: 0
)
promotional_rules = [promotion2, promotion1]
```

- Create new checkout

```ruby
item1 = Item.new('001', 'Lavender heart', 925)
item2 = Item.new('002', 'Personalised cufflinks', 4500)
item3 = Item.new('003', 'Kids T-shirt', 1995)
checkout = Checkout.new(promotional_rules)
```

- Scan items

```ruby
checkout.scan(item1)
checkout.scan(item2)
checkout.scan(item3)
```

- Print the result

```ruby
p checkout.total
```
