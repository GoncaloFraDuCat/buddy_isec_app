# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


areas_of_study = ["Business", "Economics", "Education", "Chemistry", "Journalism"]

# Generate 10 students
20.times do
 user = User.create!(
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    email: "#{Faker::Internet.user_name}@iseclisboa.pt", # Generate a random email
    bio: Faker::Lorem.paragraph(sentence_count: 5),
    area_of_study: areas_of_study.sample,
    current_year: Faker::Number.between(from: 1, to: 3),
    mentor: false, # This user is a student
    student_id: "STUDENT-#{User.count + 1}" # Example of setting student_id
 )
end

# Generate 5 mentors
10.times do
 user = User.create!(
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    email: "#{Faker::Internet.user_name}@iseclisboa.pt", # Generate a random email
    bio: Faker::Lorem.paragraph(sentence_count: 5),
    area_of_study: areas_of_study.sample,
    current_year: Faker::Number.between(from: 2, to: 3),
    mentor: true, # This user is a mentor
    student_id: "MENTOR-#{User.count + 1}" # Example of setting student_id
 )
end
