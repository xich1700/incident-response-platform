# app/models/incident_note.rb
class IncidentNote < ApplicationRecord
  belongs_to :incident
  validates :author, :body, presence: true
end

