default[:passenger][:version]     = "3.0.7"
default[:passenger][:max_pool_size] = "6"
default[:passenger][:root_path]   = "/usr/local/rvm/gems/ruby-1.9.2-p290/gems/passenger-#{passenger[:version]}"
default[:passenger][:module_path] = "#{passenger[:root_path]}/ext/apache2/mod_passenger.so"