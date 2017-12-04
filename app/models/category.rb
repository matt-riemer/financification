# Basically a Tag
class Category < ApplicationRecord

  has_many :items
  has_many :rules

  # Attributes
  # name        :string
  # heading     :string

  # debit       :boolean
  # credit      :boolean

  # timestamps

  validates :name, presence: true

  validate do
    self.errors.add(:base, 'must be debit or credit') unless (debit? || credit?)
    self.errors.add(:base, "can't be both debit and credit") if (debit? ^ credit?) # xor, can't be both
  end

  scope :sorted, -> { order(:debit, :name) }

  def to_s
    name.presence || 'New Category'
  end

end
