def curry3(proc_or_lambda)
  accumulated = []

  ->(*args) do
    accumulated += args

    if accumulated.size > 3
      raise ArgumentError, "wrong number of arguments (given #{all_args.length}, expected #{target_arity}"
    elsif accumulated.size == 3
      proc_or_lambda.call(*accumulated)
    else
      curry3(->(*more_args) { proc_or_lambda.call(*(accumulated + more_args)) })
    end
  end
end

sum3 = ->(a, b, c) { a + b + c }
cur = curry3(sum3)

f = ->(a, b, c) { "#{a}-#{b}-#{c}" }
cF = curry3(f)

puts "Variables are pre-defined: cur, sum3, f, cF"
puts "Enter your code (e.g., cur.call(1).call(2))"
puts "Type 'q' to leave."
puts "----------------------------------"

loop do
  print ">> "
  
  begin
    input = gets.chomp
    
    break if ['q'].include?(input.downcase)
    
    result = eval(input)
    
    puts "=> #{result.inspect}"
    
  rescue Exception => e
    puts "!!! Error: #{e.class} - #{e.message}"
  end
end

puts "Quiting..."
