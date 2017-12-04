# A line item from a bank account statement

class Item < ApplicationRecord
  belongs_to :account
  belongs_to :import

  belongs_to :category
  accepts_nested_attributes_for :category

  # Attributes
  # name        :string
  # date        :datetime
  # amount      :integer
  # note        :text
  # timestamps

  validates :account, presence: true
  validates :category, presence: true

  validates :date, presence: true
  validates :amount, presence: true

  def to_s
    category&.name || name.presence || 'New Item'
  end

  def rule_key
    "#{date.to_i}-#{name}-#{amount}"
  end

  # def category=(obj)
  #   if obj.kind_of?(String)
  #     super(Category.where(name: obj).first_or_create)
  #   else
  #     super
  #   end

  # end

end
