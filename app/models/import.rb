require 'csv'

class Import < ApplicationRecord
  attr_accessor :current_user

  belongs_to :account

  has_many :items
  accepts_nested_attributes_for :items

  has_many :rules
  accepts_nested_attributes_for :rules

  # Attributes
  # content      :text
  # timestamps

  before_validation :import!
  after_validation :build_rules

  validates :current_user, presence: true
  validates :account, presence: true

  # validate do
  #   self.errors.add(:base, 'uhoh')
  # end

  def to_s
    created_at&.strftime('%F') || 'New Import'
  end

  def valid_items
    items.select { |item| item.errors.blank? }
  end

  def uncategorized_items
    items.reject { |item| item.category.present? && item.category.valid? }
  end

  def new_rules
    rules.select { |rule| rule.new_record? }
  end

  protected

  # So this is going to parse each line from `content` and then find_or_initialize an item for each line
  # Try to guess the source
  # Any items where the source is not defined, we can do a create on
  def import!
    rows = begin
      CSV.parse(content.to_s)
    rescue => e
      self.errors.add(:content, "CSV parse error: #{e.message}")
      return false
    end

    rows.each_with_index do |row, index|
      begin
        date, name, amount, note = row[0], row[1], row[2], row[3]

        date = Time.zone.parse(date)
        amount = Effective::Attribute.new(:price).parse(amount)

        item = self.items.build(account: account, date: date, name: name, amount: amount, note: note)

        item.rule = (current_user.rules.find { |rule| rule.match?(item) } || new_rules.find { |rule| rule.match?(item) })
        item.category = item.rule&.category
      rescue => e
        self.errors.add(:content, "Line #{index+1} (#{row.join}): #{e.message}")
        return false
      end
    end

    true
  end

  def build_rules
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



# 2017-01-01,528 - LD SOUTHGATE       EDMONTON,21.44
# 2017-01-15,PLEASANTVIEW SOBEYSQPS   EDMONTON,45.83
# 2017-01-30,IHOP # 4004              EDMONTON,29.56
# 2017-02-01,BLIZZARD ENT*WOW SUB     BLIZZARD.C,43.10
# 2017-02-15,SENMONTENGAI THE CUBE    KYOTO,77.78
# 2017-03-01,JR KYOTO ISETAN          KYOTO,5.49
# 2017-03-15,BLIZZARD ENT*WOW SUB     BLIZZARD.C,30.53
# 2017-04-01,RED ROBIN-WEST EDMONTON  EDMONTON,17.57
# 2017-04-15,JR EAST SHOPPING CENTER  SIBUYAKU,13.05
# 2017-04-20,PAYMENT - THANK YOU,65.55
