# A line item from a bank account statement

class Item < ApplicationRecord
  belongs_to :account
  belongs_to :source

  # Attributes
  # date        :datetime
  # amount      :integer
  # note        :text
  # timestamps

  validates :account, presence: true
  validates :source, presence: true

  validates :date, presence: true
  validates :amount, presence: true

end
