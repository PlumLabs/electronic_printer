module Afip
  class ElectronicEnv
    def self.environment
      (ENV['EAFIP_ENV'] || :test).to_sym
    end

    def self.eafip_env(environment)
      production?(environment) ? :production : :test
    end

    def self.test?(environment)
      environment == :test
    end

    def self.production?(environment)
      environment == :production
    end

    def self.name
      self.environment.to_s
    end
  end
end
