class CreateBillings < ActiveRecord::Migration[5.2]
  def change
    create_table :billings do |t|
      t.integer  :customer_id
      t.integer  :document_type
      t.integer  :point_sale
      t.integer  :number
      t.datetime :emission_at
      t.decimal  :price_neto
      t.decimal  :price_final
      t.integer  :status
      t.integer  :creator_id
      t.integer  :company_id
      t.integer  :branch_id
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :fe_cae
      t.string   :fe_result
      t.string   :fe_expired
      t.string   :fe_type
      t.string   :type
      t.string   :legal_person_name
      t.string   :legal_person_document_number
      t.integer  :legal_person_type_iva
      t.string   :legal_person_address
      t.integer  :fiscal_type
      t.integer  :document_id
      t.decimal  :surchage_percentage
      t.text     :surchage_description
      t.string   :cai
      t.integer  :company_type_iva
      t.string   :company_gross_income
      t.date     :company_begin_activity
      t.string   :legal_person_gross_income
      t.date     :cai_expire_at
      t.string   :legal_person_location
      t.decimal  :balance
      t.integer  :payment_way
      t.decimal  :item_amount
      t.string   :item_description
      t.integer  :to_branch_id
      t.string   :slug
      t.integer  :provider_id
      t.string   :copy
      t.decimal  :price_iva
      t.integer  :point_sale_id
      t.boolean  :has_movements
      t.datetime :due_at

      t.timestamps
    end
  end
end
