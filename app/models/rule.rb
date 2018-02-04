# The rules for matching an item to a category

class Rule < ApplicationRecord
  belongs_to :user        # Each user has a different set of rules.
  belongs_to :import      # Just so we can build, we don't actually use this.

  belongs_to :category
  has_many :items

  MATCHES = ['match_name', 'match_note', 'match_amount', 'match_date']

  # Attributes
  # title             :string

  # match_name        :boolean
  # name              :string

  # match_note        :boolean
  # note              :string

  # match_amount       :boolean
  # amount_min         :integer
  # amount_max         :integer

  # match_date        :boolean
  # start_at          :datetime
  # end_at            :datetime

  # timestamps

  before_validation { self.title = to_s }

  validates :title, presence: true
  validates :name, presence: true, if: -> { match_name? }
  validates :note, presence: true, if: -> { match_note? }

  validates :match_name, if: -> { match_note? || match_amount? || match_date? }, presence: { message: 'required to apply additional matches' }

  validates :amount_min, presence: true, if: -> { match_amount? }
  validates :amount_max, presence: true, if: -> { match_amount? }

  validates :start_at, presence: true, if: -> { match_date? }
  validates :end_at, presence: true, if: -> { match_date? }

  # We want to validate category_id so the effective_select says "can't be blank"
  # But not enforce it when we're creating a new category
  validates :category_id, presence: true, unless: -> { category&.new_record? }
  validates :user, presence: true

  def match?(item)

    if match_name?
      return false unless item.name.downcase.include?(name.downcase)
    end

    if match_note?
      return false unless item.note.to_s.downcase.include?(note.downcase)
    end

    if match_amount? # todo rename this amount
      return false unless (amount_min..amount_max).cover?(item.amount)
    end

    if match_date?
      return false unless (start_at..end_at).cover?(item.date)
    end

    true
  end

  def to_s
    [
      (name if match_name?),
      ("note: #{note}" if match_note?),
      ("#{('%0.2f' % (amount_min / 100.0))} to #{('%0.2f' % (amount_max / 100.0))}" if match_amount?),
      ("#{start_at&.strftime('%F')} to #{end_at&.strftime('%F')}" if match_date?),
    ].compact.join(', ')
  end

end
