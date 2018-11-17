class Subject < ActiveRecord::Base
    has_many :user, :through => :joint_user_subjects
end