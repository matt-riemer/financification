# A line item from a bank account statement

class Item < ApplicationRecord
  belongs_to :account
  belongs_to :import
  belongs_to :rule

  belongs_to :category
  accepts_nested_attributes_for :category

  # Attributes
  # name        :string
  # date        :datetime
  # amount      :integer
  # note        :text
  # timestamps

  validates :account, presence: true
  validates :category, presence: true
  validates :rule, presence: true

  validates :date, presence: true
  validates :amount, presence: true

  def to_s
    category&.name || name.presence || 'New Item'
  end

  def item_key
    "#{date.to_i}-#{name}-#{amount}".hash.to_s.sub('-', '')
  end

end
