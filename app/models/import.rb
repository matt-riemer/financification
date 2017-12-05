require 'csv'

class Import < ApplicationRecord
  attr_accessor :current_user

  belongs_to :account

  has_many :rules
  accepts_nested_attributes_for :rules

  has_many :items
  accepts_nested_attributes_for :items

  # Attributes
  # content      :text
  # timestamps

  before_validation :import_content
  after_validation :build_new_rules

  validates :current_user, presence: true
  validates :account, presence: true

  scope :deep, -> { includes(:items, :rules) }

  def to_s
    created_at&.strftime('%F') || 'New Import'
  end

  def valid_items
    items.select { |item| item.errors.blank? }
  end

  def invalid_items  # We don't consider category or rule errors here
    items.select { |item| item.errors.to_h.except(:category, :rule).present? }
  end

  def uncategorized_items
    items.select { |item| item.category.blank? || item.category.valid? == false }
  end

  def new_rules
    rules.select { |rule| rule.new_record? }
  end

  protected

  # So this is going to parse each line from `content` and then find_or_initialize an item for each line
  # Try to guess the source
  # Any items where the source is not defined, we can do a create on
  def import_content
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
          account: account,
          date: Effective::Attribute.new(:date).parse(date),
          debit: (Effective::Attribute.new(:price).parse(debit) if debit),
          credit: (Effective::Attribute.new(:price).parse(credit) if credit),
          balance: (Effective::Attribute.new(:price).parse(balance) if balance),
          index: index,
          name: name,
          note: note,
          original: row.join(',')
        )

        item.rule = (current_user.rules.find { |rule| rule.match?(item) } || new_rules.find { |rule| rule.match?(item) })
        item.category = item.rule&.category
      rescue => e
        self.errors.add(:content, "Line #{index+1} (#{row.join(',')}): #{e.message}")
        return false
      end
    end

    true
  end

  def build_new_rules
    # Build a new rule for any items that are missing a category
    uncategorized_items.each do |item|
      new_rules.find { |rule| rule.item_key == item.item_key } || self.rules.build(item_key: item.item_key, name_includes: item.name)
    end

    # Assign the items so form works with new and existing (invalid) rules
    new_rules.each do |rule|
      item = items.find { |item| rule.item_key == item.item_key }
      rule.assign_attributes(item: item, item_key: item.item_key, user: current_user)
    end
  end

end
