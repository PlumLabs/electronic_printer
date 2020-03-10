class Billing < ApplicationRecord
  enum document_type: { a: 0, b: 2, c: 4, x: 6, r: 8 }
  enum legal_person_type_iva: { customer_ex: 0 , customer_mt: 1 , customer_ri: 2, customer_cf: 3,
                                provider_ex: 4 , provider_mt: 5 , provider_ri: 6, provider_cf: 7 }
  enum company_type_iva: { company_ex: 0 , company_mt: 1 , company_ri: 2 }
  # enum status: { build: 1, black: 3, active: 6, annul: 8, annul_black: 10 }
  enum status: { black: 3, active: 6, annul: 8, annul_black: 10 }
  enum fiscal_type: { ticketera: 1 , electronic: 2, local: 3 }

  has_many :items, dependent: :destroy
  belongs_to :company
  belongs_to :point_of_sale, foreign_key: :point_sale_id, class_name: '::PointSale'

  def fiscal?
    active? && point_sale.present? && number.present?
  end

  def surchage?
    surchage_percentage.present? && surchage_price > 0.0
  end

  # override this if necessary
  def extra_item?
    false
  end

  def surchage_price
    if surchage_percentage.to_f.zero?
      0.0
    else
      price_final - (price_final / Finance::percentage_to_unit(surchage_percentage))
    end
  end

  def ivas_list
    ivas = items.pluck(:iva).map{|x| x.to_f}
    ivas << 0.0 if surchage? || extra_item?
    ivas.uniq
  end
end
