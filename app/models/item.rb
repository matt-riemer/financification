# A line item from a bank account statement

class Item < ApplicationRecord
  attr_accessor :index # For import
  attr_accessor :current_step

  belongs_to :import
  belongs_to :account, optional: true  # Only required once import is completed

  belongs_to :category
  accepts_nested_attributes_for :category, reject_if: Proc.new { |atts| atts['name'].blank? && atts['category_group_id'].blank? }

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

  # Fix a newly built category
  before_validation(if: -> { category&.new_record? }) do
    category.debit = true if debit.present?
    category.credit = true if credit.present?
    category.user = import.account.user
  end

  # Fix a newly built rule
  before_validation(if: -> { rule&.new_record? }) do
    rule.category = category
    rule.user = import.account.user
  end

  # So this starts off as a valid item if name, date, amount, balance

  # Then we categorize it
  validates :category_id, presence: true, if: -> { current_step == :categorize && category.blank? }

  # Then we assign an account, and it's fully done.
  validates :category_id, presence: true, if: -> { account.present? }
  validates :category, presence: true, if: -> { account.present? }

  validates :name, presence: true, uniqueness: { scope: [:date, :debit, :credit, :balance], message: 'already exists' }
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
    [category&.name, date.to_s.presence, name.presence, amount.presence].compact.join(' - ').presence || 'New Item'
  end

  def row_errors
    errors.messages
      .slice(:date, :name, :debit, :credit, :balance)
      .map { |k, v| "#{k} #{v.flatten.first}" }
      .to_sentence
      .sub('name already exists', 'you already imported this item')
      .sub('debit at least one required, credit at least one required', "amount can't be blank")
  end

  def amount
    debit || credit
  end

end
