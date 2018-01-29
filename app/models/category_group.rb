# Basically a Tag
class CategoryGroup < ApplicationRecord
  belongs_to :user

  has_many :categories

  # Attributes
  # name        :string
  # position    :integer

  # timestamps

  validates :name, presence: true
  validates :user, presence: true

end
