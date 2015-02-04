bibi = Member.find_or_create_by(:name => "bibi netanyahu")
likud = Party.find_or_create_by(:name => "likud")
bibi.parties.append likud

kadima = Party.find_or_create_by(:name => "kadima")
tnua = Party.find_or_create_by(:name => "tnua")
avoda = Party.find_or_create_by(:name => "avoda")

zipi = Member.find_or_create_by(:name => "tzipi livni")
zipi.parties.append([ likud, kadima, tnua, avoda ])
stav = Member.find_or_create_by(:name => "stav shafir")
stav.parties.append([ avoda ])
sheli = Member.find_or_create_by(:name => "shelly yichemovitz")
sheli.parties.append([ avoda ])


afula = City.find_or_create_by(:name => "afula", :lat => 32.613104, :lng => 35.284166)
kesaria = City.find_or_create_by(:name => "kesaria", :lat => 32.501726, :lng => 34.892629)
netanya = City.find_or_create_by(:name => "netanya", :lat => 32.327070, :lng => 34.857270)
givataim = City.find_or_create_by(:name => "givataim",:lat => 32.072541, :lng => 34.809648)
telaviv = City.find_or_create_by(:name => "talaviv", :lat => 31.899121, :lng => 34.679601)



bibi.update_attribute(:city,kesaria)
zipi.update_attribute(:city,afula)
stav.update_attribute(:city,telaviv)
sheli.update_attribute(:city,telaviv)
