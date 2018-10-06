require 'faker'

def rand_coordinates
  {
    coordinate_x: Faker::Number.between(1, 100),
    coordinate_y: Faker::Number.between(1, 100),
    coordinate_z: Faker::Number.between(1, 100),
  }
end

london = Location.create!(rand_coordinates.merge(name: 'London'))
paris = Location.create!(rand_coordinates.merge(name: 'Paris'))
tokyo = Location.create!(rand_coordinates.merge(name: 'Tokyo'))

30.times do
  Location.create!(rand_coordinates.merge(name: Faker::Address.city))
end

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
