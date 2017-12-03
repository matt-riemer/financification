# A line item from a bank account statement

class Item < ApplicationRecord
  belongs_to :account
  belongs_to :source

  # Attributes
  # name        :string
  # date        :datetime
  # amount      :integer
  # note        :text
  # timestamps

  validates :account, presence: true
  validates :source, presence: true

  validates :date, presence: true
  validates :amount, presence: true

  def to_s
    source&.name || name.presence || 'New Item'
  end

end
