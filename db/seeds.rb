bibi = Member.find_or_create_by(:name => "bibi netanyahu")
likud = Party.find_or_create_by(:name => "likud")
bibi.parties.append likud

kadima = Party.find_or_create_by(:name => "kadima")
tnua = Party.find_or_create_by(:name => "tnua")
avoda = Party.find_or_create_by(:name => "avoda")

zipi = Member.find_or_create_by(:name => "tzipi livni")
zipi.parties.append([ likud, kadima, tnua, avoda ])
