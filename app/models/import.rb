require 'csv'

class Import < ApplicationRecord
  attr_accessor :current_step
  attr_accessor :current_user

  STEPS = {
    start:  'Start Import',
    categorize: 'Categorize Items',
    review: 'Review Items',
    complete: 'Completed'
  }

  STATUSES = [:started, :categorized, :reviewed, :completed]

  belongs_to :account

  has_many :rules
  accepts_nested_attributes_for :rules

  has_many :items, -> { order(:id).merge(Item.deep) }
  accepts_nested_attributes_for :items

  # Attributes
  # content      :text
  # status       :string
  # timestamps

  # Create an approved scope and approved? method for each status
  STATUSES.each do |sym|
    define_method("#{sym}?") { status == sym.to_s }
    scope(sym, -> { where(status: sym.to_s ) })
  end

  validates :current_user, presence: true
  validates :account, presence: true

  scope :deep, -> { includes(:rules, items: :category) }

  def to_s
    created_at&.strftime('%F') || 'New Import'
  end

  # Items that we couldn't even import
  def invalid_items
    items.select { |item| item.errors.present? }
  end

  def uncategorized_items
    items.select { |item| item.category.blank? || item.errors.present? }
  end

  def start!
    import_and_validate_items!
    assign_item_categories!
    save!
  end

  def categorize!
    assign_item_categories!
    save!
  end

  def complete!
    items.each { |item| item.account = account }
    save!
  end

  protected

  def assign_item_categories!
    account.user.rules.each do |rule|
      uncategorized_items.each do |item|
        next unless rule.match?(item)

        item.rule = rule
        item.category = rule.category
      end
    end
  end

  def import_and_validate_items!
    rows = begin
      CSV.parse(content.to_s)
    rescue => e
      self.errors.add(:content, "CSV parse error: #{e.message}")
      return false
    end

    imported = (rows.first[0] == 'Date') ? import_td_canada_trust(rows) : import_servus(rows)

    raise 'import error' unless imported
  end

  def import_td_canada_trust(rows)
    rows.each_with_index do |row, index|
      begin
        date, name, debit, credit, balance, note = row[0], row[1], row[2], row[3], row[4], row[5]

        next if (date == 'Date' || ['Name', 'Transaction'].include?(name) || ['Debit', 'Withdrawl'].include?(debit))

        item = self.items.build(
          account: nil,  # These aren't processed yet, so we don't assign them to an account.
          date: Effective::Attribute.new(:date).parse(date),
          debit: (Effective::Attribute.new(:price).parse(debit) if debit),
          credit: (Effective::Attribute.new(:price).parse(credit) if credit),
          balance: (Effective::Attribute.new(:price).parse(balance) if balance),
          index: index,
          name: name,
          note: note,
          original: row.join(',')
        )
      rescue => e
        self.errors.add(:content, "Line #{index+1} (#{row.join(',')}): #{e.message}")
        return false
      end
    end

    true
  end

  def import_servus(rows)
    rows.each_with_index do |row, index|
      begin
        id, date, account, name, amount, balance, note = row[0], row[1], row[2], row[3], row[4], row[5], row[6]

        next if (id == 'ID' || date == 'Date' || account == 'Account Name' || amount == 'Amount')
        next if (id == ' ID' || date == ' Date' || account == ' Account Name' || amount == ' Amount')

        amount = Effective::Attribute.new(:price).parse(amount)
        balance = Effective::Attribute.new(:price).parse(balance)

        # Parse Date
        digits = date.to_s.scan(/(\d+)/).flatten
        date = Time.zone.local(digits[2], digits[1], digits[0])

        item = self.items.build(
          account: nil,  # These aren't processed yet, so we don't assign them to an account.
          date: date,
          debit: (amount.abs if amount <= 0),
          credit: (amount.abs if amount > 0),
          balance: balance,
          index: index,
          name: name,
          note: note,
          original: row.join(',')
        )
      rescue => e
        self.errors.add(:content, "Line #{index+1} (#{row.join(',')}): #{e.message}")
        return false
      end
    end

    true
  end

end
