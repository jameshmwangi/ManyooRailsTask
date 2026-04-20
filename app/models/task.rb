class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  # Map integer values to named priorities
  enum priority: { low: 0, medium: 1, high: 2 }

  # Map integer values to named statuses
  enum status: { not_started: 0, in_progress: 1, completed: 2 }

  # Sort by deadline ascending, then newest created first as tiebreaker
  scope :sort_deadline_on, -> { order(deadline_on: :asc, created_at: :desc) }

  # Sort by priority descending (high first), then newest created first
  scope :sort_priority, -> { order(priority: :desc, created_at: :desc) }

  # Default sort: newest created first
  scope :sort_created_at, -> { order(created_at: :desc) }

  # Fuzzy search by title
  scope :search_title, ->(title) { where('title LIKE ?', "%#{title}%") }

  # Exact match search by status
  scope :search_status, ->(status) { where(status: status) }
end
