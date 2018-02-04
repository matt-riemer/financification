class Category < ApplicationRecord
  belongs_to :user
  belongs_to :category_group

  has_many :items
  has_many :rules

  # Attributes
  # name        :string

  # debit       :boolean
  # credit      :boolean

  # position    :integer

  # timestamps

  validates :name, presence: true
  validates :user, presence: true

  validates :category_group_id, presence: true

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

  validate(if: -> { category_group }) do
    unless category_group.debit? == debit?
      self.errors.add(:category_group_id, 'heading must match category debit/credit')
    end
  end

  scope :sorted, -> { order(:position, :name) }

  def to_s
    name.presence || 'New Category'
  end

end
