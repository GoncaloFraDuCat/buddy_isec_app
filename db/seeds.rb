# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

areas_of_study = ['Comunicação Global', 'Design e Produção Gráfica', 'Educação Básica', 'Engenharia de Proteção Civil',
                  'Energias Renováveis e Ambiente', 'Gestão Aeronáutica', 'Gestão Autárquica', 'Gestão Hoteleira', 'Óptica e Optometria', 'Ciências Aeronáuticas e do Espaço', 'Ciência e Visualização de Dados']

# Set Faker to use Portuguese locale
Faker::Config.locale = 'pt'

# Track used email addresses to ensure uniqueness
used_emails = []

# Generate 20 students
20.times do
  begin
    email = "#{Faker::Internet.unique.user_name}@iseclisboa.pt"
  end while used_emails.include?(email) # Ensure uniqueness manually, if needed

  used_emails << email

  User.create!(
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    email: email,
    bio: Faker::Lorem.paragraph(sentence_count: 5),
    area_of_study: areas_of_study.sample,
    current_year: 1,
    mentor: false,
    student_id: Faker::Number.number(digits: 6),
    ajuda_social: false,
    apoio_estudo: false,
    apoio_bolsas: false
  )
end

# Generate 10 mentors
10.times do
  begin
    email = "#{Faker::Internet.unique.user_name}@iseclisboa.pt"
  end while used_emails.include?(email)

  used_emails << email

  User.create!(
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    email: email,
    bio: Faker::Lorem.paragraph(sentence_count: 5),
    area_of_study: areas_of_study.sample,
    current_year: Faker::Number.between(from: 2, to: 3),
    mentor: true,
    student_id: Faker::Number.number(digits: 6),
    ajuda_social: [true, false].sample,
    apoio_estudo: [true, false].sample,
    apoio_bolsas: [true, false].sample
  )
end

# Admin user
if ENV['ADMIN_EMAIL'].present?
  User.create!(
    name: 'Admin',
    email: ENV['ADMIN_EMAIL'],
    bio: 'I am the administrator of this application.',
    area_of_study: 'Computer Science',
    current_year: 3,
    mentor: true,
    student_id: Faker::Number.number(digits: 6)
  )
end