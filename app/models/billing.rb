class Billing < ApplicationRecord
  enum document_type: { a: 0, b: 2, c: 4, x: 6, r: 8 }
  enum legal_person_type_iva: { customer_ex: 0 , customer_mt: 1 , customer_ri: 2, customer_cf: 3,
                                provider_ex: 4 , provider_mt: 5 , provider_ri: 6, provider_cf: 7 }
  enum company_type_iva: { company_ex: 0 , company_mt: 1 , company_ri: 2 }
  # enum status: { build: 1, black: 3, active: 6, annul: 8, annul_black: 10 }
  enum status: { black: 3, active: 6, annul: 8, annul_black: 10 }

  def fiscal?
    active? && point_sale.present? && number.present?
  end
end
