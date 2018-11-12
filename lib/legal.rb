module Legal
  RI = ["ri", "customer_ri", "company_ri", "provider_ri"].freeze
  EX = ["ex", "customer_ex", "company_ex", "provider_ex"].freeze
  MT = ["mt", "customer_mt", "company_mt", "provider_mt"].freeze
  CF = ["cf", "customer_cf"].freeze

  def self.valid?(data)
    v = 54327654321.to_s.split('')
    cuit = data.gsub(/\D/, '').split('')
    cuit.length == 11 && cuit.zip(v).inject(0) {|s, p| s += p[0].to_i * p[1].to_i}.multiple_of?(11)
  end

  def self.invalid_cuit?(data)
    ! self.valid?(data)
  end

  def self.format_cuit(data)
    if data.present?
      cuit = data.gsub(/\D/, '')
      cuit.insert(-2, '-').insert(2,'-')
    end
  end

  def self.unformat_cuit(data)
    data.gsub(/\D/, '') if data.present?
  end

  def self.document_type(company_iva, customer_iva)
    # a: ri -> ri
    # b: ri -> cualquiera
    # c: mt -> cualquiera
    # b: ex -> cualquiera
    if RI.include?(company_iva)
      return :a if RI.include?(customer_iva)
      return :b
    elsif MT.include?(company_iva)
      return  :c
    elsif EX.include?(company_iva)
      return :b
    else
      # raise Exception.new "Invalid Iva Condition. Company #{company_iva}"
      return nil
    end
  end
end
