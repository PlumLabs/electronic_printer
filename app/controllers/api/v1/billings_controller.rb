class Api::V1::BillingsController < ApplicationController
  # facturar ( ok si recibio todo y pudo facturar, error si falta algo o error de facturacion)
  def bill
    Billing.transaction do
      begin
        @document = Billing.create billing_params
        errors = []
        if params[:pkey].blank? || params[:cert].blank?
          render status: 404, json: { message: I18n.t('electronic.errors.files_not_found') }
          raise ActiveRecord::Rollback, I18n.t('electronic.errors.files_not_found')
        else
          fe = Fiscals::Printers::Electronic.new(@document, params)
          unless fe.call
            fe.errors.each do |error|
              errors << error
            end
            render status: 404, json: { message: errors } and return
          end
          render status: 200, json: { status: 200 } and return
        end
      rescue ActiveRecord::StatementInvalid
        # ...which we ignore.
      end
    end



  end

  # consultar estado de factura (datos electronicos de la factura)
  def state
    if params[:invoice].present? && params[:invoice][:slug].present?
      billing = Billing.find_by(slug: params[:invoice][:slug])
      if billing.present?
        fe_respond = {
          fe_cae: document.fe_cae,
          fe_result: document.fe_result,
          fe_type: document.fe_type,
          fe_expired: document.fe_expired,
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

  def billing_params
    params.require(:invoice).permit :customer_id, :document_type, :point_sale, :number,
      :emission_at, :price_neto, :price_final, :status, :creator_id, :company_id, :branch_id,
      :legal_person_name, :legal_person_document_number, :legal_person_type_iva,
      :legal_person_address, :surchage_percentage, :surchage_description, :company_type_iva,
      :company_gross_income, :legal_person_location, :balance, :payment_way, :slug, :price_iva,
      :point_sale_id, :has_movements, :document_id, :due_at, :remito_id
  end
end
