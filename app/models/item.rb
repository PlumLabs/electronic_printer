class Item < ApplicationRecord
  belongs_to :billing

  def discount_unitary
    default_unit_price * Finance.percentage_to_decimal(discount)
  end

  def price_unitary
    default_unit_price - discount_unitary
  end

  def price_unitary_with_iva
    price_unitary * Finance.percentage_to_unit(iva)
  end

  def price_discount
    discount_unitary * quantity
  end

  def price_neto
    price_unitary * quantity
  end

  def _price_iva
    price_neto * Finance.percentage_to_decimal(iva)
  end

  def calculated_subtotal
    price_neto * Finance.percentage_to_unit(iva)
  end

  private

  def default_unit_price
    unit_price || 0.0
  end
end
