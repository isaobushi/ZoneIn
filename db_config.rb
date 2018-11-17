require 'active_record'
options = {
    adapter: 'postgresql',
    database: 'student_tool'
}


ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
