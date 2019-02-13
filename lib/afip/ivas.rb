module Afip::Ivas
  def self.ivas_document(document)
    data = []
    unless document.c?
      document.ivas_list.each do |x|
        case x.to_i
          when 21
            data << Eafip::Eiva.new(key_iva: :iva_21,
                                    base_imp: self.base_imp(document, 21.0),
                                    amount: self.price_iva(document, 21.0))
          when 10
            data << Eafip::Eiva.new(key_iva: :iva_10,
                                    base_imp: self.base_imp(document, 10.5),
                                    amount: self.price_iva(document, 10.5))
          when 27
            data << Eafip::Eiva.new(key_iva: :iva_27,
                                    base_imp: self.base_imp(document, 27.0),
                                    amount: self.price_iva(document, 27.0))
          else
            base_imp = self.base_imp(document, 0.0)
            base_imp += document.surchage_price if document.surchage?
            data << Eafip::Eiva.new(key_iva: :iva_0,
                                    base_imp: base_imp,
                                    amount: 0.0)
        end
      end
    end
    data
  end

  def self.price_iva(document, iva)
    Finance::presition(document.items.where(iva: iva).inject(0){ |sum, item| sum + item._price_iva })
  end

  def self.base_imp(document, iva)
    Finance::presition(document.items.where(iva: iva).inject(0){ |sum, item| sum + item.price_neto })
  end
end
