def play_game(num)
	print "Enter ur first guess: "
	guess = gets.to_i
	guesses = 1
	while guess != num
		guesses += 1
		if guess < num
			puts "More"
		elsif guess > num
			puts "Less"
		end
		print "Retry: "
                guess = gets.to_i
	end
	puts ("Congatulations! U got it in " + guesses.to_s + " attempts")	
end

num = rand(100)
play_game(num)
