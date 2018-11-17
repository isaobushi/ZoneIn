require 'sinatra' 
require 'pg'
require 'pry'
require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/subject'
require_relative 'models/question'
require_relative 'models/student_score'
require_relative 'models/joint_user_subject'


# binding.pry