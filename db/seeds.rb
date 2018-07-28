london = Location.create!(name: 'London')
Location.create!(name: 'Paris')
Location.create!(name: 'Tokyo')

Location.all.each do |location|
  Dock.create!(location: location)
end

Person.create!(
  name: 'Luke',
  location: london,
  ship: Ship.create!(dock: london.establishments.first, location: london)
)
