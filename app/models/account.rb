# Kind of account   Debit   Credit
# Asset             Increase  Decrease
# Liability         Decrease  Increase
# Income/Revenue    Decrease  Increase
# Expense           Increase  Decrease
# Equity/Capital    Decrease  Increase

class Account < ApplicationRecord
  belongs_to :user

  has_many :items, dependent: :delete_all

  has_many :debits, -> { joins(:source).where(source: { category: 'Debit' }) }    # Incomes - Increase value of Asset account
  has_many :credits, -> { joins(:source).where(source: { category: 'Credit' }) }  # Expenses - Decrease value of Asset account

  CATEGORIES = ['Asset', 'Liability', 'Income/Revenue', 'Expense', 'Equity/Capital']

  # Attributes
  # name        :string
  # category    :string
  # timestamps

  validates :user, presence: true
  validates :name, presence: true
  validates :category, inclusion: { in: CATEGORIES }

  after_initialize do
    self.category ||= 'Asset'
  end

end
