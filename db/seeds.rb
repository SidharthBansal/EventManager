# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@user = User.create(
  username: "Ninja",
  email: "ninja@email.com",
  password: "foobar",
  password_confirmation: "foobar"
)

5.times do
  Event.create(
    host_id: @user.id,
    title: Faker::Pokemon.name,
    body: Faker::Lorem.sentence(10),
    location: Faker::Address.street_address,
    date: Faker::Date.forward(100)

  )
end
