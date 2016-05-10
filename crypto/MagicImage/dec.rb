#!/usr/bin/env ruby
#encoding:utf-8
key = [3,63,101,21,118,234,37,188,42,211,181,13]

data = ""
File.open("enc.png","r") do |f|
	i=0
	until f.eof?
		f.read(12).each_byte do |c| 
			data += (c ^ key[i%12]).chr
			i+=1
		end
	end
end

File.open("dec.png","w") do |f|
	f.write(data)
end
