# A line item from a bank account statement

class Item < ApplicationRecord
  attr_accessor :index # For import
  attr_accessor :current_step

  belongs_to :import
  belongs_to :account, optional: true  # Only required once import is completed

  belongs_to :category
  accepts_nested_attributes_for :category, reject_if: Proc.new { |atts| atts['name'].blank? }

  belongs_to :rule, optional: true # Not required
  accepts_nested_attributes_for :rule, reject_if: Proc.new { |atts| Rule::MATCHES.all? { |match| [0, '0', nil, '', false, 'false'].include?(atts[match]) } }

  # Attributes
  # name        :string
  # date        :date

  # debit       :integer
  # credit      :integer
  # balance     :integer

  # note        :string
  # original    :string

  # timestamps

  scope :debits, -> { where.not(debit: nil) }
  scope :credits, -> { where.not(credit: nil) }

  scope :deep, -> { includes(:account, :category, :import, :rule) }
  scope :sorted, -> { order(:date) }

  before_validation do
    self.credit = nil if credit == 0
    self.debit = nil if debit == 0
  end

  validates :account, presence: true, if: -> { import&.completed? }
  validates :category, presence: true, if: -> { import&.completed? }
  validates :category_id, presence: true, if: -> { persisted? }

  validates :name, uniqueness: { scope: [:date, :debit, :credit, :balance], message: 'item already exists' }
  validates :date, presence: true
  validates :balance, presence: true

  validate do
    unless (debit.present? || credit.present?)
      self.errors.add(:debit, 'at least one required')
      self.errors.add(:credit, 'at least one required')
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

  def row_errors
    errors.messages.slice(:date, :name, :debit, :credit, :balance).map { |k, v| "#{k} #{v.flatten.first}" }.to_sentence
  end

  def amount
    debit || credit
  end

end
