FactoryBot.define do
  factory :incident_note do
    incident { nil }
    author { "MyString" }
    body { "MyText" }
  end
end
