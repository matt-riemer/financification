# Kind of account   Debit   Credit
# Asset             Increase  Decrease
# Liability         Decrease  Increase
# Income/Revenue    Decrease  Increase
# Expense           Increase  Decrease
# Equity/Capital    Decrease  Increase

class Account < ApplicationRecord
  belongs_to :user

  has_many :imports, dependent: :delete_all
  has_many :items, dependent: :delete_all

  has_many :debits, -> { joins(:category).where(categories: { debit: true }) }, class_name: 'Item'    # Incomes - Increase value of Asset account
  has_many :credits, -> { joins(:category).where(categories: { credit: true }) }, class_name: 'Item'  # Expenses - Decrease value of Asset account

  CATEGORIES = ['Asset', 'Liability', 'Income/Revenue', 'Expense', 'Equity/Capital']

  scope :deep, -> { includes(debits: :category, credits: :category) }

  # Attributes
  # name        :string
  # category    :string
  # timestamps

  validates :user, presence: true
  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  after_initialize do
    self.category ||= 'Asset'
  end

  def to_s
    name
  end

end
