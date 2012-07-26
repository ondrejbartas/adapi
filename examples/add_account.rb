# encoding: utf-8

require 'adapi'

$account = Adapi::ManagedCustomer.new(
  :name => 'Test Account ',
  :currency_code => 'CZK',
  :date_time_zone => 'Europe/Prague'

)

$account.create

unless $account.errors.empty?

  puts "ERROR WHEN CREATING ACCOUNT \"#{$account[:name]}\":"
  pp $account.errors.full_messages

else

  puts "CREATED ACCOUNT \"#{$account[:name]}\":"

#  $account = Adapi::ManagedCustomer.find $account[:id]

  puts "\nACCOUNT DATA:"
  pp $account.attributes

end
