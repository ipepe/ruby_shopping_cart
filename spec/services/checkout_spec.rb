# frozen_string_literal: true

require_relative '../../app/services/checkout'
require_relative '../../app/models/promotional_rule'
require_relative '../../app/models/product'

RSpec.describe Checkout do
  context 'when promotional_rules are passed' do
    it 'discounts whole order' do
      # Basket: 001, 002, 003
      # Total price expected: £66.78

      promotional_rules = PromotionalRule.all

      checkout = Checkout.new(promotional_rules)

      checkout.scan(Product.find('001'))
      checkout.scan(Product.find('002'))
      checkout.scan(Product.find('003'))

      expect(checkout.total_without_discounts).to eq(BigDecimal('74.2'))
      expect(checkout.discount).to eq(BigDecimal('7.42'))
      expect(checkout.order_discounts).to eq(BigDecimal('7.42'))
      expect(checkout.products_discounts).to eq(BigDecimal('0'))
      expect(checkout.total).to eq(BigDecimal('66.78'))
    end

    it 'discounts one product' do
      # Basket: 001, 003, 001
      # Total price expected: £36.95

      promotional_rules = PromotionalRule.all

      checkout = Checkout.new(promotional_rules)

      checkout.scan(Product.find('001'))
      checkout.scan(Product.find('003'))
      checkout.scan(Product.find('001'))

      expect(checkout.total_without_discounts).to eq(38.45)
      expect(checkout.total).to eq(36.95)
      expect(checkout.discount).to eq(1.5)
    end

    it 'discounts one product and whole order at same time' do
      # Basket: 001, 002, 001, 003
      # Total price expected: £73.76
      promotional_rules = PromotionalRule.all

      checkout = Checkout.new(promotional_rules)

      checkout.scan(Product.find('001'))
      checkout.scan(Product.find('002'))
      checkout.scan(Product.find('001'))
      checkout.scan(Product.find('003'))

      expect(checkout.total_without_discounts).to eq(BigDecimal('83.45'))
      expect(checkout.products_discounts).to eq(BigDecimal('1.5'))
      expect(checkout.order_discounts * 10)
        .to eq(BigDecimal('83.45') - BigDecimal('1.5'))
      expect(checkout.total).to eq(BigDecimal('73.76'))
    end
  end
end
