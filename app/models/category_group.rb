# Basically a Tag
class CategoryGroup < ApplicationRecord
  belongs_to :user

  has_many :categories, -> { order(:position, :name) }

  # Attributes
  # name        :string
  # debit       :boolean
  # credit      :boolean

  # position    :integer

  # timestamps

  validates :name, presence: true
  validates :user, presence: true

  validate do
    unless (debit? || credit?)
      self.errors.add(:debit, 'at least one required')
      self.errors.add(:credit, 'at least one required')
    end

    unless (debit? ^ credit?) # xor
      self.errors.add(:debit, "can't be both")
      self.errors.add(:credit, "can't be both")
    end
  end

end
