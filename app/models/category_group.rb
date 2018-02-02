# Basically a Tag
class CategoryGroup < ApplicationRecord
  belongs_to :user

  has_many :categories, -> { order(:name) }

  # Attributes
  # name        :string
  # debit       :boolean
  # credit      :boolean

  # position    :integer

  # timestamps

  validates :name, presence: true
  validates :user, presence: true

end
