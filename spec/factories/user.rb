FactoryBot.define do
  factory :user do
    id {1}
    first_name { 'Max' }
    last_name { 'Mustermann' }
    email { 'mustermann@example.com' }
    password { 'password'}
  end

  factory :admin do
    id {2}
    first_name { 'Maria' }
    last_name { 'Musterfrau' }
    email { 'musterfrau@example.com' }
    password { 'password'}
  end
end
