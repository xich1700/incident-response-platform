FactoryBot.define do
  factory :incident_analysis do
    incident { nil }
    error_event { nil }
    status { "MyString" }
    root_causes { "MyText" }
    affected_components { "MyText" }
    investigation_steps { "MyText" }
    raw_response { "" }
    error_message { "MyText" }
  end
end
