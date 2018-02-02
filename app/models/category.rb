# Basically a Tag
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
    self.errors.add(:debit_or_credit, "can't be blank") unless (debit? || credit?)
    self.errors.add(:debit_or_credit, "can't be both") unless (debit? ^ credit?) # xor
  end

  validate(if: -> { category_group }) do
    self.errors.add(:category_group_id, 'heading must match category debit/credit') unless category_group.debit? == debit?
  end

  scope :sorted, -> { order(:debit, :name) }

  def to_s
    name.presence || 'New Category'
  end

  def debit_or_credit
    return 'Debit' if debit?
    return 'Credit' if credit?
  end

  def debit_or_credit=(value)
    self.credit = true if Array(value).include?('Credit')
    self.debit = true if Array(value).include?('Debit')
  end

end
