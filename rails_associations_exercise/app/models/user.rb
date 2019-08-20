# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_many :enrollments,
    class_name: 'Enrollment',
    primary_key: :id,
    foreign_key: :student_id

  has_many :enrolled_courses,
    through: :enrollments,
    source: :course

  has_many :taught_courses,
    class_name: 'Course',
    primary_key: :id,
    foreign_key: :instructor_id

  has_many :instructors,   
    through: :enrolled_courses,
    source: :instructor

  has_many :taught_students,
    through: :taught_courses,
    source: :enrolled_students  
end
