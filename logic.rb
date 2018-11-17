



require 'pry' 

@level = 2

def gen_question() 
    level = @level.floor
    
    if level == 1 # w/answer a % b = ?
        y = rand(5..10)
        x = y + rand(2..y)
        ans = x % y 
        question = "#{x} % #{y} = #{ans}"
    
    elsif level == 2 #no answer
        x, y = rand(2..20), rand(2..10)
        ans = x % y 
        question = "#{x} % #{y} = ?"

    elsif level == 3 #  x+y first
        x, y, z = rand(2..20), rand(2..20), rand(2..10)
        ans = (x + y) % z
        question = "(#{x} + #{y}) % #{z}"
    
    elsif level == 4 #  x*y first
        x, y, z = rand(2..20), rand(2..20), rand(2..10)
        ans = (x * y) % z
        question = "(#{x} * #{y}) % #{z}"

    elsif level == 5 # x*y first
        x, y, z, w = rand(2..20), rand(2..20), rand(2..20), rand(2..10)
        ans = (x * y) % (z + w)
        question = "(#{x} * #{y}) % (#{z} + #{w}) = ?"
   
    else # Fail gracefully
        return 
    end
    puts question
    answer = gets.chomp.to_i
    
    if answer == ans
        update_level @level, true
        gen_question()

    else 
        update_level @level, false
        gen_question()
    end
end


def update_level level, correct #(true, false)
    if correct
        delta = +1.0/3  # 3 right answers to pass the level
    else
        delta =  -1.0/6 # 6 wrong answers to downgrade
    end
    
    if level.floor < (level + delta).floor
        delta += 1.0/3
    end
    
    level += delta
    
    if level.ceil - level < 0.001
        level = level.ceil
    end
    
    level = (1..level).max
    
    if level.floor == 6
        print ('Congratulation, you completed all the levels!')
    end
    
    @level = level
    return  @level
end



gen_question()

# while true 
#     print @level.floor
#     inp = gets("Pass? (y/n)")
#     @level = update_level(@level, inp.downcase == 'y'.chomp)
# end



# i = (2...7)
# i.each do |num|
# puts "level #{num}"
#     j = (0..2)
#     j.each do |num2|
#         answer, question = gen_question(num)
#         if num = 1 && num2 = 0
#             puts answer,question
#             binding.pry
#         end
#     end
# end


# puts fisrt level question 
# gets input and matches it with answer 
# runs update_level with current level and boolean
#update_level(1, right)
# delta = +1/3
# level = 1 +1/3
# 