# frozen_string_literal: true

require 'active_hash'

class Product < ActiveHash::Base
  self.data = [
    { id: '001', name: 'Red Scarf', price: BigDecimal('9.25') },
    { id: '002', name: 'Silver cufflinks', price: BigDecimal('45') },
    { id: '003', name: 'Silk Dress', price: BigDecimal('19.95') }
  ]
end
