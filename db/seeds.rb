london = Location.create!(name: 'London')
Location.create!(name: 'Paris')
Location.create!(name: 'Tokyo')

Location.all.each do |location|
  Dock.create!(name: "#{location.name} Dock", location: location)
end

Person.create!(
  name: 'Luke',
  location: london,
  ship: Ship.create!(
    dock: london.establishments.first,
    fuel: Space::Flight::Ship::FUEL_MAX,
    name: 'Endeavour',
    location: london
  )
)
