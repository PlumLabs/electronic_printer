class Fiscals::Printers::Electronic
  require 'invoicef'
  attr_accessor :document, :errors

  def initialize(document, params)
    @document = document
    @params = params
    @errors = []
  end

  def call
    electronic_bill
  end

  private

  def valid?
    @params[:company].blank? || @params[:point_sale].blank? || @params[:items].blank?
  end

  def electronic_bill
    bill = Afip::Invoicef.new(@document, @params)
    if bill.authorize
      true
    else
      @errors = bill.errors.values
      false
    end
  end
end

