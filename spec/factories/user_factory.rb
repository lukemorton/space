FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Company.bs }

    trait :with_person do
      after(:create) do |user|
        create(:person, user: user)
      end
    end
  end
end
