class Fiscals::Printers::Electronic
  require 'invoicef'
  attr_accessor :document, :errors

  def initialize(document, enviroment)
    @document = document
    @enviroment = enviroment
    @errors = []
  end

  def call
    electronic_bill
  end

  private

  def electronic_bill
    bill = Afip::Invoicef.new(@document, @enviroment)
    if bill.authorize
      true
    else
      @errors = bill.errors.values
      false
    end
  end
end

