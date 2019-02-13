module Afip
  class UpdateFiscalData
    attr_accessor :document

    def initialize(document, params)
      @params = params
      @document = document
    end

    def electronic
      process build_electronic_params
    end

    def electronic!
      process! build_electronic_params
    end

    def call(point_sale)
      if point_sale.electronic?
        electronic
      elsif point_sale.ticketera?
        ticketera
      else
        local
      end
    end

    private

    def build_electronic_params
      {
        point_sale: @params[:header_response][:pto_vta],
        number: @params[:detail_response][0][:cbte_desde],
        status: :active,
        fiscal_type: :electronic,
        fe_cae: @params[:detail_response][0][:cae],
        fe_result: @params,
        fe_type: @params[:header_response][:cbte_tipo],
        fe_expired: @params[:detail_response][0][:cae_fch_vto].to_date,
        document_type: @params[:document_type]
      }
    end

    def process(params)
      begin
        process!(params)
        true
      rescue ActiveRecord::RecordInvalid => exception
        false
      end
    end

    def process!(params)
      ActiveRecord::Base.transaction do
        @document.update_attributes! params
      end
    end
  end
end
