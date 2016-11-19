# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


#CREATING MEMBERS
puts "Creating Victor Navarro User"
member = Member.create!(name: 'Victor Navarro', alias: 'vi',
email: 'victor@gmail.com', password: 'testtest', password_confirmation: 'testtest')

puts "Creating Alax Alves User"
member2 = Member.create!(name: 'Luan Guimaraes', alias: 'lu',
email: 'luan@gmail.com', password: 'testtest', password_confirmation: 'testtest')

puts "Creating Matheus Miranda User"
member3 = Member.create!(name: 'Matheus Miranda', alias: 'mirandinhazika',
email: 'matheus@gmail.com', password: 'testtest', password_confirmation: 'testtest')

puts "Creating Sabrayna Santos User"
member4 = Member.create!(name: 'Sabrayna Santos', alias: 'sabrayna',
email: 'sabrayna@gmail.com', password: 'testtest', password_confirmation: 'testtest')

puts "Creating Luan Guimarães User"
member5 = Member.create!(name: 'Alax Alves', alias: 'alax',
email: 'alax@gmail.com', password: 'testtest', password_confirmation: 'testtest')

puts "Creating Jessica Cristina User"
member6 = Member.create!(name: 'Jéssica Cristina', alias: 'je',
email: 'jessica@gmail.com', password: 'testtest', password_confirmation: 'testtest')

puts "Creating Vitor Barbosa User"
member7 = Member.create!(name: 'Vitor Barbosa', alias: 'vivi',
email: 'vitor@gmail.com', password: 'testtest', password_confirmation: 'testtest')


#CREATING ROOMS
puts "Creating Humanidade e Cidadania room"
room = member2.my_rooms.create!(name: 'Humanidade e Cidadania', description: 'Professora Sônia Albuquerque')

puts "Creating Fundamentos de Sistemas Distribuidos room"
room2 =member2.my_rooms.create!(name: 'Fundamentos de Sistemas Distribuidos', description: 'Professor Fernando W. Cruz')

puts "Creating Palestra Empreendendo sua ideia room"
room3 = member.my_rooms.create!(name: 'Palestra Empreendendo sua Ideia', description: 'Palestrante José Joaquim')

#APPENDING ROOMS TO MEMBERS
puts "#{room.name} to #{member.name}, #{member3.name}, #{member4.name}, #{member5.name}, #{member6.name}"
member6.rooms << room
member5.rooms << room
member4.rooms << room
member3.rooms << room
member.rooms << room

puts "#{room2.name} to #{member.name}"
member.rooms << room2

puts "#{room3.name} to #{member2.name}"
member2.rooms << room3


#CREATING TOPICS
puts "Creating topics for topic: #{room.name}"
top = room.topics.create(name: "O futuro do Planeta Terra", description: "Discuta aqui sobre medidadas para ajudar o mundo!")
top1 = room.topics.create(name: "Reciclando e Empreendendo", description: "Palestra do professor Jão Carlos")
top2 = room.topics.create(name: "Soluções Energéticas", description: "Soluções para o problema de energia do futuro!")


#CREATING QUESTIONS
puts "Creating questions for topic: #{top.name}"
ask = top.questions.new(content: "Eu não entendi o sentido do filme Avatar")
ask2 = top.questions.new(content: "Tenho uma ideia para isso e preciso de pessoas interessadas!")
ask3 = top.questions.new(content: "Tenho uma ideia!")

member4.questions << ask
member.questions << ask2
member.questions << ask3

ask.save
ask2.save
ask3.save

ans = ask.answers.new(content: "E alguém sabe?")
ans2 = ask.answers.new(content: "A professora já ira falar sobre o filme.")

member2.answers << ans
member3.answers << ans2

ans.save
ans2.save
