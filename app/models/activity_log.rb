class ActivityLog < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :product, optional: true

  validates :action, :description, presence: true
end
