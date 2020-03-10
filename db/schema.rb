# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_08_131054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billings", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "document_type"
    t.integer "point_sale"
    t.integer "number"
    t.datetime "emission_at"
    t.decimal "price_neto"
    t.decimal "price_final"
    t.integer "status"
    t.integer "creator_id"
    t.integer "company_id"
    t.integer "branch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fe_cae"
    t.string "fe_result"
    t.string "fe_expired"
    t.string "fe_type"
    t.string "type"
    t.string "legal_person_name"
    t.string "legal_person_document_number"
    t.integer "legal_person_type_iva"
    t.string "legal_person_address"
    t.integer "fiscal_type"
    t.integer "document_id"
    t.decimal "surchage_percentage"
    t.text "surchage_description"
    t.string "cai"
    t.integer "company_type_iva"
    t.string "company_gross_income"
    t.date "company_begin_activity"
    t.string "legal_person_gross_income"
    t.date "cai_expire_at"
    t.string "legal_person_location"
    t.decimal "balance"
    t.integer "payment_way"
    t.decimal "item_amount"
    t.string "item_description"
    t.integer "to_branch_id"
    t.string "slug"
    t.integer "provider_id"
    t.string "copy"
    t.decimal "price_iva"
    t.integer "point_sale_id"
    t.boolean "has_movements"
    t.datetime "due_at"
  end

  create_table "companies", force: :cascade do |t|
    t.integer "type_iva"
    t.string "cuit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.integer "quantity"
    t.integer "currency_id"
    t.decimal "unit_price", precision: 11, scale: 2
    t.decimal "discount", precision: 11, scale: 2
    t.decimal "iva", precision: 11, scale: 2
    t.decimal "subtotal", precision: 11, scale: 2
    t.decimal "margin", precision: 11, scale: 2
    t.decimal "price_iva", precision: 11, scale: 2
    t.decimal "normalize_price_cost", precision: 11, scale: 3
    t.decimal "quotation", precision: 11, scale: 3
    t.integer "product_id"
    t.integer "billing_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "point_sales", force: :cascade do |t|
    t.integer "company_id"
    t.integer "pos_number", default: 0
    t.integer "concept", default: 0, null: false
    t.integer "fiscal_type", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
