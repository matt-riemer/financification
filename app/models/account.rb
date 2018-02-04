# Kind of account   Debit   Credit
# Asset             Increase  Decrease
# Liability         Decrease  Increase
# Income/Revenue    Decrease  Increase
# Expense           Increase  Decrease
# Equity/Capital    Decrease  Increase


# Chequing
# Savings
# Line of Credit
# Credit Card

class Account < ApplicationRecord
  belongs_to :user

  has_many :imports, dependent: :delete_all
  has_many :items, -> { order(:date, :id) }, dependent: :delete_all

  has_many :debits, -> { where.not(debit: nil) }, class_name: 'Item'    # Incomes - Increase value of Asset account
  has_many :credits, -> { where.not(credit: nil) }, class_name: 'Item'  # Expenses - Decrease value of Asset account

  CATEGORIES = ['Asset', 'Liability', 'Income/Revenue', 'Expense', 'Equity/Capital']

  scope :deep, -> { includes(debits: :category, credits: :category) }

  # Attributes
  # name        :string
  # category    :string   # Just a category string field that does nothing. Not a Category.
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

  def items_by_year
    @items_by_year ||= items.deep.group_by { |item| item.date.year }
  end

  #
  # ['Heading' => [['Category', 1, 2, 3...100],[...]]
  #

  def rows_by_heading(date: nil, debits: nil, credits: nil)
    items = self.items.includes(:category)
    items = items.where(date: date) if date
    items = items.debits if debits
    items = items.credits if credits

    # Groups now
    categories = items.map { |item| item.category }.uniq
    monthly = items.group_by { |item| "#{item.category_id}_#{item.date.month}" }
    totally = items.group_by { |item| item.category_id }

    # For each category, category, months, total
    categories.map do |category|
      [category] + months.map do |month|
        monthly.fetch("#{category.id}_#{month.month}", []).map { |item| item.amount }.sum
      end + [totally.fetch(category.id, []).map { |item| item.amount }.sum]
    end

  end


  # collection do
  #   # All year items
  #   items = account.items.includes(:category).where(date: months.first.all_year).to_a

  #   # Items scoped by debits or credits
  #   items = items.select { |item| item.debit.present? } if debits?
  #   items = items.select { |item| item.credit.present? } if credits?

  #   # All the groups
  #   categories = items.map { |item| item.category }.uniq
  #   monthly = items.group_by { |item| "#{item.category_id}_#{item.date.month}" }
  #   totally = items.group_by { |item| item.category_id }

  #   # For each category, category, months, total
  #   categories.map do |category|
  #     [category] + months.map do |month|
  #       monthly.fetch("#{category.id}_#{month.month}", []).map { |item| item.amount }.sum
  #     end + [totally.fetch(category.id, []).map { |item| item.amount }.sum]
  #   end
  # end

end
