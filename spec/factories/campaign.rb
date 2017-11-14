FactoryBot.define do
  factory :campaign do
    title { "New Secret Santa" }
    description { "Add a description..." }
    user
    status { :pending }
    locale { "#{FFaker::Address.city}, #{FFaker::Address.street_address}" }
    event_date { FFaker::Time.date }
    event_hour { rand(24).to_s }
  end
end
