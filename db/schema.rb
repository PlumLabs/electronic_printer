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

ActiveRecord::Schema.define(version: 2018_11_09_140452) do

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

end
