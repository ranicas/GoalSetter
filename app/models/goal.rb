class Goal < ActiveRecord::Base
  validates :status, :body, :user, presence: true
  validates :status, inclusion: { in: ["PRIVATE", "PUBLIC"] }
  belongs_to :user
end
