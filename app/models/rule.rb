# The rules for matching an item to a category

class Rule < ApplicationRecord
  attr_accessor :item
  attr_accessor :item_key

  belongs_to :user        # Each user has a different set of rules.
  belongs_to :import      # Just so we can build, we don't actually use this.

  belongs_to :category
  accepts_nested_attributes_for :category, reject_if: Proc.new { |atts| atts['name'].blank? }

  # Attributes
  # name_includes            :string

  # timestamps

  validates :name_includes, presence: true

  # We want to validate category_id so the effective_select says "can't be blank"
  # But not enforce it when we're creating a new category
  validates :category_id, presence: true, unless: -> { category&.new_record? }
  validates :user, presence: true

  def match?(item)
    item.name.include?(name_includes)
  end

  def to_s
    "Name includes: #{name_includes}"
  end

end
