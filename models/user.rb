class User < ActiveRecord::Base
    has_secure_password
    has_many :subject
    has_many :score
end