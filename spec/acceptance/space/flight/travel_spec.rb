require 'rails_helper'

RSpec.describe Space::Flight::Travel do
  example 'travelling' do
    person = Person.create!(name: 'Cool', location: 'France')
    person_gateway = Space::Flight::PersonGateway.new(person_repository: Person)
    Space::Flight::Travel.new(person_gateway: person_gateway).travel(person.id, to: double)
  end
end
