module Afip
  class ElectronicEnv
    def self.environment
      (ENV['EAFIP_ENV'] || :test).to_sym
    end

    def self.eafip_env
      self.production? ? :production : :test
    end

    def self.test?
      self.environment == :test
    end

    def self.production?
      self.environment == :production
    end

    def self.name
      self.environment.to_s
    end
  end
end
