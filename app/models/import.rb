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

  has_many :items, -> { order(:id) }
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

  scope :deep, -> { includes(:items, :rules) }

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
    import_and_validate_items && save!
  end

  protected

  def import_and_validate_items
    rows = begin
      CSV.parse(content.to_s)
    rescue => e
      self.errors.add(:content, "CSV parse error: #{e.message}")
      return false
    end

    rows.each_with_index do |row, index|
      begin
        date, name, debit, credit, balance, note = row[0], row[1], row[2], row[3], row[4], row[5]

        next if date == 'Date' || ['Name', 'Transaction'].include?(name) || ['Debit', 'Withdrawl'].include?(debit)

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

  # def build_new_rules
  #   # Build a new rule for any items that are missing a category
  #   uncategorized_items.each do |item|
  #     new_rules.find { |rule| rule.item_key == item.item_key } || self.rules.build(item_key: item.item_key, name_includes: item.name)
  #   end

  #   # Assign the items so form works with new and existing (invalid) rules
  #   new_rules.each do |rule|
  #     item = items.find { |item| rule.item_key == item.item_key }
  #     rule.assign_attributes(item: item, item_key: item.item_key, user: current_user)
  #   end
  # end

end
