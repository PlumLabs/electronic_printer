require 'eafip'
Eafip.logger            = { log: true, level: :debug }
if Rails.env.production?
  Eafip.openssl_bin       = '/usr/bin/openssl'
else
  Eafip.openssl_bin       = ENV['EAFIP_PATH_ENV'] || '/usr/bin/openssl'
end
