london = Location.create!(name: 'London')
Location.create!(name: 'Paris')
Location.create!(name: 'Tokyo')

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

%i(Luke Gem).each do |name|
  Person.create!(
    name: name,
    location: london,
    ship: ship
  )
end
