# The rules for matching an item to a category

class Rule < ApplicationRecord
  attr_accessor :item
  attr_accessor :item_key

  belongs_to :user        # Each user has a different set of rules.
  belongs_to :import      # Just so we can build, we don't actually use this.

  belongs_to :category
  accepts_nested_attributes_for :category

  # Attributes
  # name_includes            :string

  # timestamps

  validates :name_includes, presence: true

  validates :category_id, presence: true
  validates :user, presence: true

  def match?(item)
    item.name.include?(name_includes)
  end

  def to_s
    "Name includes: #{name_includes}"
  end

end
