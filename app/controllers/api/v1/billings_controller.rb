class Api::V1::BillingsController < ApplicationController

  # facturar ( ok si recibio todo y pudo facturar, error si falta algo o error de facturacion)
  def bill
    Billing.transaction do
      begin
        @document = initialize_document
        errors = []
        puts "inside billing controller before new service"
        fe = Fiscals::Printers::Electronic.new(@document, @enviroment)
        puts "inside billing controller before call service"
        unless fe.call
          fe.errors.each do |error|
            errors << error
          end
          render status: 404, json: { message: errors } and return
        end

        render json: @document.attributes.except("id") and return

      rescue ActiveRecord::StatementInvalid
        render json: "StatementInvalid"
        # ...which we ignore.
      end
    end
  end

  # consultar estado de factura (datos electronicos de la factura)
  def state
    if params[:invoice].present? && params[:invoice][:id].present?
      billing = Billing.find(params[:invoice][:id])
      if billing.present?
        fe_respond = {
          fe_cae: billing.fe_cae,
          fe_result: billing.fe_result,
          fe_type: billing.fe_type,
          fe_expired: billing.fe_expired,
        }.to_json
        render status: 200, json: { billing: fe_respond }
      else
        render status: 404, json: { message: I18n.t('electronic.errors.document_not_found') }
      end
    else
      render status: 404, json: { message: I18n.t('electronic.errors.invoice_blank') }
    end
  end

  # enviar los datos de billing (ok. error si falta alguno)
  def send_data
    render status: 500, json: { message: I18n.t('electronic.errors.invoice_blank') } and return if params[:invoice].blank?
    render status: 500, json: { message: I18n.t('electronic.errors.company_blank') } and return if params[:company].blank?
    render status: 500, json: { message: I18n.t('electronic.errors.point_sale_blank') } and return if params[:point_sale].blank?
    render status: 500, json: { message: I18n.t('electronic.errors.item_blank') } and return if params[:item].blank?
    render status: 200, json: { status: 200 } and return
  end

  private

  def initialize_document
    @enviroment = params[:enviroment]
    point_sale = PointSale.create point_sale_params
    company    = Company.create company_params
    document   = Billing.create billing_params
    document.point_of_sale = point_sale
    document.company       = company
    create_items(document)
    document
  end

  def create_items(document)
    items = JSON.parse(params[:items])
    items.each do |item_param|
      document.items.build item_param.except("id", "document_id", "quantity_in_box",
        "update_stock", "update_price", "exento_neto_gravado", "taxes", "retention",
        "perception", "other")
    end
    document.save
  end

  def billing_params
    JSON.parse(params.require(:invoice)).slice("customer_id", "document_type", "point_sale", "number",
      "emission_at", "price_neto", "price_final", "status", "creator_id", "company_id", "branch_id",
      "legal_person_name", "legal_person_document_number", "legal_person_type_iva",
      "legal_person_address", "surchage_percentage", "surchage_description", "company_type_iva",
      "company_gross_income", "legal_person_location", "balance", "payment_way", "slug", "price_iva",
      "point_sale_id", "has_movements", "document_id", "due_at", "remito_id")
  end

  def point_sale_params
    JSON.parse(params.require(:point_sale)).slice("company_id", "pos_number", "concept", "fiscal_type")
  end

  def company_params
    JSON.parse(params.require(:company)).slice("cuit", "type_iva")
  end

  def items_params
    params.require(:items).slice("discount", "unit_price", "quantity", "product_id",
                         "subtotal", "description", "code", "iva", "margin", "normalize_price_cost",
                         "quotation", "currency_id", "price_iva")
  end
end
