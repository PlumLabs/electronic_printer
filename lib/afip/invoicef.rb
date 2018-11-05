require_relative 'exceptions'
require_relative 'ivas'
require_relative 'electronic_env'

module Afip
  class Invoicef
    attr_reader :errors

    PRICE_LIMIT = 1000.0

    def initialize(invoice)
      @invoice = invoice
      @invoice.document_type = Legal::document_type(@invoice.company_type_iva, @invoice.legal_person_type_iva)
      @errors   = {}
      @eafip = Eafip::Company.new({ cuit: @invoice.company.unformat_cuit,
                                   pto_venta: @invoice.branch.default_point_sale.pos_number.to_s.rjust(4, '0'),
                                   documento: document_type,
                                   pkey: Rails.env.production? ? @invoice.company.pkey.url : @invoice.company.pkey.path,
                                   cert: Rails.env.production? ? @invoice.company.cert.url : @invoice.company.cert.path,
                                   concepto: @invoice.branch.default_point_sale.concept,
                                   moneda: :peso,
                                   iva_cond: company_iva_condition,
                                   environment:  Afip::ElectronicEnv.eafip_env
                                 })
    end

    def authorize
      return false unless validate_data?

      begin
        ActiveRecord::Base.transaction do
          raise Afip::Exceptions::AlreadyInvoiced if @invoice.fiscal?

          bill = Eafip::Bill.new(@eafip, {bill_type: bill_type, invoice_type: invoice_type})
          # Creamos un Invoice y pasamos total, tipo de invoice, condición de IVA
          # del receptor y porcentaje de IVA a aplicar. (0% o 21% para consumidor final)
          invoice = Eafip::Bill::Invoice.new(@eafip, {total: @invoice.price_final,
                                             document_type: document_type,
                                             iva_condition: iva_condition,
                                             list_ivas: map_ivas_amount,
                                             bill_type: bill.bill_type,
                                             concept: point_sale_concept,
                                             net_amount: net_amount})
                                             # iva_sum: iva_sum,
          # Agregamos DNI o CUIT
          invoice.document_number = customer_document_number

          # Agregamos este Invoice al Bill
          bill.set_new_invoice(invoice)
          # Enviamos la solicitud a la AFIP
          fail_billing!(bill) unless bill.authorize
          response = bill.response
          Documents::UpdateFiscalData.new(@invoice,
            response.to_h.merge({document_type: @invoice.document_type})).electronic!
        end

      rescue Eafip::NullOrInvalidAttribute => e
        @errors[:invoice_number] = invalid_attribute_on
        @errors[:invalid_attribute] = e.message
        puts e.message
        false
      rescue Afip::Exceptions::BravoAfipError => e
        # Add tracker for FE
        # Eafip::Wsaa.login if e.message.include? "AfipError - 600"
        @errors[:afip_error] = e.message
        puts e.message
        false
      rescue ActiveRecord::RecordInvalid => e
        # Add tracker for FE
        @errors[:record_invalid] = "Lo sentimos. Se realizo la Fiscalización, pero ocurrio un error al actualizar los datos"
        @errors[:record_invalid] += e.message
        puts e.message
        false
      rescue Afip::Exceptions::AlreadyInvoiced => e
        # Add tracker for FE
        @errors[:already_invoiced] = I18n.t('electronic.errors.already_invoiced')
        puts e.message
        false
      rescue Exception => e
        puts e.backtrace.join("\n\t")
        @errors[:base] = e.message
        puts e.message
        false
      end
    end

    private

    def invalid_attribute_on
      @invoice.customer_cf? ? 'DNI' : 'CUIT'
    end

    def bill_type
      if @invoice.a?
        :bill_a
      elsif @invoice.b?
        :bill_b
      else
        :bill_c
      end
    end

    def invoice_type
      if @invoice.instance_of? Invoice
        :invoice
      elsif @invoice.instance_of? DebitNote
        :debit
      else
        :credit
      end
    end

    def document_type
      doc_number = @invoice.legal_person_document_number.gsub('-','')
      if !@invoice.a? && @invoice.price_final < PRICE_LIMIT
        'Doc. (Otro)'
      else
        if doc_number.size == 11
          'CUIT'
        elsif doc_number.present?
          'DNI'
        else
          'Doc. (Otro)'
        end
      end
    end

    def iva_condition
      if @invoice.customer_ri?
        :responsable_inscripto
      elsif @invoice.customer_mt?
        :responsable_monotributo
      else
        :consumidor_final
      end
    end

    def map_ivas_amount
      @_map_ivas_amount ||= Afip::Ivas.ivas_document(@invoice)
    end

    def net_amount
      Finance::presition(@invoice.price_neto)
    end

    def customer_document_number
      doc_number = @invoice.legal_person_document_number.gsub('-','')
      doc_number = "0" if doc_number.blank? || (!@invoice.a? && @invoice.price_final < PRICE_LIMIT)
      doc_number
    end

    def point_sale_concept
      I18n.t("point_sale.concept.#{@invoice.branch.default_point_sale.concept}")
    end

    def validate_data?
      # if @invoice.company.ex?
      #   errors[:exento] = I18n.t('electronic.errors.exent_not_support')
      #   return false
      # end
      if !@invoice.customer_ri? && @invoice.legal_person_document_number.blank? && @invoice.price_final >= PRICE_LIMIT
        errors[:customer] = I18n.t('electronic.errors.customer_doc_big_sales', price_limit: PRICE_LIMIT)
        return false
      end
      if @invoice.customer_ri? && @invoice.legal_person_document_number.gsub('-','').size != 11
        errors[:customer] = I18n.t('electronic.errors.cuit_not_present', price_limit: PRICE_LIMIT)
        return false
      end
      true
    end

    def company_iva_condition
      if @invoice.company.ri?
        :responsable_inscripto
      elsif @invoice.company.mt?
        :responsable_monotributo
      else
        :exento
      end
    end

    def fail_billing!(bill)
      begin
      msj = bill.response.detail_response[0][:observaciones][:obs][:msg]
      rescue
        msj = bill.response.to_s
      end
      raise Afip::Exceptions::BravoAfipError, msj
    end
  end
end
