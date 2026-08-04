FactoryBot.define do
  factory :incident do
    title { "MyString" }
    status { "MyString" }
    resolved_at { "2026-08-03 19:00:03" }
    error_event { nil }
  end
end
