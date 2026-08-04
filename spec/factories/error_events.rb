FactoryBot.define do
  factory :error_event do
    application { nil }
    error_type { "MyString" }
    error_message { "MyText" }
    stack_trace { "MyText" }
    occurred_at { "2026-08-03 18:59:39" }
    severity { "MyString" }
  end
end
