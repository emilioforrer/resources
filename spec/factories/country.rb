FactoryGirl.define do
  factory :country, class: Country do
    code Faker::Code.isbn
    name  Faker::Address.country
    active [0,1].sample
  end
end
