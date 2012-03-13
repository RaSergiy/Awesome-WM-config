#!/usr/bin/ruby -Ku

if @p = `acpi`.match(/Battery 0: ([a-zA-Z]*), ([0-9]*)%/)
  res = 
  if @p[1]=='Charging'
    '↑'
  elsif @p[1]=='Discharging'
    if (lev=Integer(@p[2]))<=10
      if lev<=3
        `sudo swapon -a`
        `sudo pm-hibernate`
      end
      '↓:    WARNING! LOW BATTERY LEVEL   '
    else
      '↓'
    end
  elsif @p[1]=='Unknown'
    ''
  else '?' end
  puts "B:%s%%%s" % [@p[2], res]
end

