User.create!(
  name: "kugyu10",
  email: "kugyu10@gmail.com",
  password: "qwertyui9",
  password_confirmation: "qwertyui9",
  admin: true
)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "qwertyui9"

  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password
  )
end
