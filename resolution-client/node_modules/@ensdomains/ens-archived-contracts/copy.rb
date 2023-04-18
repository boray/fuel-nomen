require 'fileutils'

%w(
  dnsprovejs
  dnsregistrar
  dnssec-oracle
  ens
  ens-022
  ethregistrar
  ethregistrar-202
  resolver
  subdomain-registrar
).each do |path|
   name = path.split('/')[-1]
   path = "node_modules/@ensdomains/#{name}"
   newpath = "abis/#{name}"
   unless Dir.exists?(newpath)
    FileUtils.mkdir_p newpath
   end
   system "cp -rf #{path}/build/contracts/*  #{newpath}/"
end