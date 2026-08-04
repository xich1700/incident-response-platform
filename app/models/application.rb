# app/models/application.rb
class Application < ApplicationRecord
  has_many :error_events
end

