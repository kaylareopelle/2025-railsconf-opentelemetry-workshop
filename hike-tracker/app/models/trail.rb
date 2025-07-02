class Trail < ApplicationRecord
  has_many :activities, dependent: :destroy
  has_many :comments, dependent: :destroy
end
