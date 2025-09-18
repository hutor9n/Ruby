def word_stats(text)
	i = ""
	text.split().each do |word|
		if word.length >= i.length
			i = word
		end
	end
	puts((text.split().length()).to_s + " слів, " + "найдовше: " + i.to_s + ", унікальних: " + (text.downcase.split().uniq).length().to_s)
end

puts "Write ur sentence:"
text = gets.chomp()

word_stats(text)
