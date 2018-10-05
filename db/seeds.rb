require 'faker'

london = Location.create!(name: 'London')
paris = Location.create!(name: 'Paris')
tokyo = Location.create!(name: 'Tokyo')

Location.all.each do |location|
  Dock.create!(name: "#{location.name} Dock", location: location)
end

User.create!(
  email: 'luke@example.com',
  password: 'password'
)

ship = Ship.create!(
  dock: london.establishments.first,
  fuel: Space::Flight::Ship::FUEL_MAX,
  name: 'Endeavour',
  location: london
)

50.times do
  location = [london, paris, tokyo].sample

  Ship.create!(
    dock: location.establishments.first,
    fuel: Space::Flight::Ship::FUEL_MAX,
    name: Faker::Space.meteorite,
    location: location
  )
end

%i(Jim Gem).each do |name|
  user = User.create!(
    email: "#{name.downcase}@example.com",
    password: 'password'
  )

  Person.create!(
    name: name,
    location: london,
    ship: ship,
    user: user
  )
end
