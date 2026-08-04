# app/models/incident.rb
class Incident < ApplicationRecord
  belongs_to :error_event, optional: true
  has_many :incident_notes
  has_many :incident_analyses
  validates :title, :status, presence: true
end

