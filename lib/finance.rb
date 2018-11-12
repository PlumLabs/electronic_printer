module Finance
  PRESITION = 2
  class << self
    def percentage_to_unit(value)
      return 1.0 if value.blank? || value.zero?
      1 + (value / 100.0)
    end

    def percentage_to_decimal(value)
      return 0.0 if value.blank? || value.zero?
      (value / 100.0)
    end

    def presition(value)
      value.round(PRESITION)
    end

    def item_price(unit_price, quantity, perc_discount)
      real_discount = unit_price * percentage_to_decimal(perc_discount)
      (unit_price - real_discount) * quantity
    end

    def truncate(value)
      format = "%0.#{PRESITION}f"
      BigDecimal.new(format % value)
    end
  end
end