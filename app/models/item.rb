# A line item from a bank account statement

class Item < ApplicationRecord
  attr_accessor :index # Just for import

  belongs_to :account
  belongs_to :category
  belongs_to :import
  belongs_to :rule

  accepts_nested_attributes_for :category

  # Attributes
  # name        :string
  # date        :date

  # debit       :integer
  # credit      :integer
  # balance     :integer

  # note        :string
  # original    :string

  # timestamps

  scope :deep, -> { includes(:account, :category, :import, :rule) }
  scope :sorted, -> { order(:date) }

  before_validation do
    self.credit = nil if credit == 0
    self.debit = nil if debit == 0
  end

  validates :account, presence: true
  validates :category, presence: true
  validates :rule, presence: true

  validates :name, uniqueness: { scope: [:date, :debit, :credit, :balance], message: 'item already exists' }
  validates :date, presence: true
  validates :balance, presence: true

  validate do
    unless (debit.present? || credit.present?)
      self.errors.add(:debit, "can't be blank")
      self.errors.add(:credit, "can't be blank")
    end

    unless (debit.present? ^ credit.present?) # xor
      self.errors.add(:debit, "can't be both")
      self.errors.add(:credit, "can't be both")
    end
  end

  def to_s
    [category&.name, date.to_s.presence, name.presence, (debit || credit).presence].compact.join(' - ').presence || 'New Item'
  end

  # We need an item key to link a non-persisted rule to a non-persisted item during an import
  def item_key
    "#{date}-#{name}-#{debit}-#{credit}-#{balance}".hash.to_s.sub('-', '')
  end

  def amount
    debit || credit
  end

end
