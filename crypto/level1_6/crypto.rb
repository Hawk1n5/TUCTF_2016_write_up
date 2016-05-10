#!/usr/bin/env ruby
require '~/Tools/pwnlib'
require 'morse'
host, port = '146.148.102.236', 24069

def read(str="a")
	puts "[!] round : "+@r.recv_capture(/Round (.*)\. Give me some text:/)[0]
	@r.send("#{str}\n")	
	space = @r.recv_capture(/. encrypted is (.)/)[0]
	return @r.recv_capture(/What is (.*) decrypted\?\n/)[0], space
end

def read1()
	puts "[!] round : "+@r.recv_capture(/Round (.*)\. Give me some text:/)[0]
	@r.send("bfmtgwisdaro\n")
	table  = @r.recv_capture(/bfmtgwisdaro encrypted is (.{12})/)[0]
	#table = @r.recv_capture(/bfmtgwisdaro encrypted is (.*)/)[0]
	return @r.recv_capture(/What is (.*) decrypted\?\n/)[0], table
end
def level34(str, space=" ")
	split = str.split(space)
	#puts "[!] str : #{str},[!] space : #{space},[!] size : #{split.size}"
	case split.size
	when 1
		return "bastian" if split[0].size == 7
		return "fragmentation"	
	when 2
		return "my luckdragon"  if split[0].size == 2
		return "mono child" 	if split[0].size == 4
		return "giant turtle" 	if split[0].size == 5
		return "gmorks cool" 	if split[0].size == 6
		return "welcome atreyu" if split[0].size == 7
		if split[0].size == 3
			return "the oracle"   if split[1].size == 6
			return "the nuthing"  if split[1].size == 7
			return "try swimming" if split[1].size == 8
		end
	when 3
		return "i owa you" 	       if split[0].size == 1
		return "atreyu vs gmork"       if split[0].size == 6
		return "reading is dangerours" if split[0].size == 7
		return "dont forget auryn"     if split[1].size == 6
		return "save the princess"
	end
end

def level5(str)
		#abcdefghijklmnopqrstuvwxyz
	table = ">=<;:9876543210/.-,+*)('&%"
	case str[0]
	when '>' #'a'
		return "atreyu vs gmork"
	when '=' #'b'
		return "bastian"
	when '9' #'f'
		return "fragmentation"
	when '6' #'i'
		return "i owa you"	
	when ',' #'s'
		return "save the princess"
	when ';' #'d'
		return "dont forget auryn"
	when '-' #'r'
		return "reading is dangerours"
	when '(' #'w'
		return "welcome atreyu"
	when '2' #'m'
		return "my luckdragon" if str[1] == '&'
		return "mono child"
	when '8' #'g'
		return "giant turtle"  if str[1] == '6'
		return "gmorks cool"
	when '+' #'t'
		return "try swimming" if str[1] == '-'
		return "the nuthing"  if str[4] == '1'
		return "the oracle" 
	end
end

def level6(str, table)
	# 012345678901
	# bfmtgwisdaro encrypted is 
	# 6BWlEuKi<3f]
	# What is W]]Z.9HKT< decrypted?
	case str[0]
	when table[0] #'b'
		return "bastian"
	when table[1] #'f'
		return "fragmentation"
	when table[5] #'w'
		return "welcome atreyu"
	when table[6] #'i'
		return "i owa you"	
	when table[7] #'s'
		return "save the princess"
	when table[8] #'d'
		return "dont forget auryn"
	when table[9] #'a'
		return "atreyu vs gmork"
	when table[10]#'r'
		return "reading is dangerours"
	when table[2] #'m'
		return "moon child" if str[1] == table[11]
		return "my luckdragon"
	when table[4] #'g'
		return "giant turtle"  if str[1] == table[6]
		return "gmorks cool"
	when table[3] #'t'
		return "try swimming" if str[1] == table[10]
		return "the oracle"   if str[4] == table[11]
		return "the nuthing" 
	end
end
def rot13(str)
	ans = ""
	table = " !\"\#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}"	
	str.each_byte do |c|
		index = table.index(c.chr)
		if index > 12
			ans << table[index-13]
		else
			ans << table[index+table.size-12]
		end
	end
	return ans
end
PwnTube.open(host, port) do |r|
	@r = r
	#level1 morse
	50.times do |c| 
		str, space  = read()
		ans = Morse.decode(str)
		@r.send("#{ans}\n")
		puts ans+@r.recv_until("Correct!")
	end
	#level2 rot13
	50.times do |c|
		str, space  = read()
		ans = rot13(str)
		@r.send("#{ans}\n")
		puts ans+@r.recv_until("Correct!")
	end
	50.times do |c|
		str, space = read()
		#puts "[!] str : #{str}"
		ans = level34(str)
		@r.send("#{ans}\n")
		puts ans+@r.recv_until("Correct!")
	end
	50.times do |c|
		str, space = read(" ")
		ans = level34(str, space)
		@r.send("#{ans}\n")
		puts ans+@r.recv_until("Correct!")
	end
	50.times do |c|
		str, space = read()
		ans = level5(str)
		@r.send("#{ans}\n")
		puts ans+@r.recv_until("Correct!")
	end
	50.times do |c|
		str, table = read1()
		ans = level6(str, table)
		@r.send("#{ans}\n")
		puts ans+@r.recv_until("Correct!")
	end
	@r.interactive()
end
