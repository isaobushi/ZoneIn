require 'sinatra' 
# require 'sinatra/reloader'
require 'pg'
require 'pry'
require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/subject'
require_relative 'models/question'
require_relative 'models/student_score'
require_relative 'models/joint_user_subject'



enable :sessions



helpers do 

  def logged_in? 
     !!current_user
  end
  
  def current_user 
    User.find_by(id: session[:user_id])
  end

end

get '/' do
  redirect to('/profile')
end

get '/login' do
  @u = current_user
  erb :login
end


post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id ] = user.id
    redirect to('/subject')
  else
    erb :login
  end
end


delete '/session' do 
  # raise 'dsfsdfs'
  session[:user_id] = nil
  redirect to('/login')
end

get '/new' do
  erb :new
end


post '/login' do
  @u = current_user
  user = User.new
  user.email = params[:email]
  user.password = params[:password]
  user.level = 2
  user.name = params[:name]
  user.avatar = params[:img_url]
  user.save

redirect to('/login')
end


post '/profile' do
  @joint = JointUserSubject.new
  @joint.user_id = current_user.id
  @joint.subject_id = params[:subject_id]
  @joint.level = current_user.level
  @joint.save
  redirect to('/profile')
end


get '/profile' do
  if logged_in?
    @u = current_user
    @s = Subject.all
    @user_subjects = JointUserSubject.where(user_id: current_user.id)
    JointUserSubject.where(user_id: current_user.id).each do |user|
      user.level = @u.level
      user.save
    end
    @user_level = JointUserSubject.where(user_level: current_user.id)
    erb :profile
  else
    redirect to('/login')
  end
end

get '/subject' do
  if logged_in?
    @joint = JointUserSubject.all
    @u = current_user
    @subjects = Subject.all
    erb :subject
  else
    redirect to('/login')
  end
end

def gen_question()
  level = @u.level.floor
  # if level == 1 # w/answer a % b = ?
  #     y = rand(5..10)
  #     x = y + rand(2..y)
  #     @result = x % y 
  #     @domanda = "#{x} % #{y} = #{@result}"
  
  if level == 2 #no answer
      y =  rand(2..10)
      x = y + rand(2..20)
      @result = x % y 
      @domanda = "#{x} % #{y} = ?"
      
  elsif level == 3 #  x+y first
      x, y, z = rand(2..20), rand(2..20), rand(2..10)
      @result = (x + y) % z
      @domanda = "(#{x} + #{y}) % #{z}"

  elsif level == 4 #  x*y first
      x, y, z = rand(2..20), rand(2..20), rand(2..10)
      @result = (x * y) % z
      @domanda = "(#{x} * #{y}) % #{z}"

  elsif level == 5 # x*y first
      x, y, z, w = rand(2..20), rand(2..20), rand(2..20), rand(2..10)
      @result = (x * y) % (z + w)
      @domanda = "(#{x} * #{y}) % (#{z} + #{w}) = ?"
 
  else # Fail gracefully
    return 
  end
  @question = Question.new
  @question.level = level
  @question.subject_id = @subject.id
  @question.result = @result
  @question.save
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

  if level.ceil - level < 0.01
      level = level.ceil
  end
  
  level = (1..level).max
  
  if level.floor >= 6
    # binding.pry
    print ('Congratulation, you completed all the levels!')
    redirect to("/result/#{@subject.id}")
  end
  @u = User.find(params[:user_id])
  @u.level = level
  @u.save
end


get '/test/:subject_id' do 
  @subject = Subject.find_by(id: params[:subject_id])
  @subject.save
  if logged_in?
    @u = current_user
    if @u.level >= 2.00
      gen_question()
    elsif @u.level < 2.00 
      @u.level = 2.00
      @u.save
      gen_question()
    end
    erb :test
  else
    redirect to('/login')
  end
end


get '/result/:subject_id' do
  @number_questions = Question.where(subject_id: params[:subject_id]).count
  @results = StudentScore.where(subject_id: params[:subject_id]).where(user_id: current_user.id)
  @right_ans = @results.where(score: 1).count
  erb :result
end
post '/result/:subject_id' do 
  @u = current_user
  @subject = Subject.find_by(id: params[:subject_id])
  @question = Question.find(params[:result])
  @answer = params[:solution].to_i
  @score = StudentScore.new
  @score.question_id = @question.id
  @score.user_id = @u.id
  @score.subject_id = @question.subject_id
  @score.save
        if @answer == @question.result.to_i
          #update student score
          @score.score = 1
          @score.save
          update_level(@u.level, 'correct')
          gen_question()
        else 
          @score.score = 0
          @score.save
          update_level(@u.level, !'correct')
          gen_question()
        end
  redirect to("/test/#{params[:subject_id]}")
end
