london = Location.create!(name: 'London')
Location.create!(name: 'Paris')
Location.create!(name: 'Tokyo')

Person.create!(
  name: 'Luke',
  location: london,
  ship: Ship.create!(location: london)
)
