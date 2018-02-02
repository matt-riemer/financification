# The rules for matching an item to a category

class Rule < ApplicationRecord
  belongs_to :user        # Each user has a different set of rules.
  belongs_to :import      # Just so we can build, we don't actually use this.

  belongs_to :category
  has_many :items

  MATCHES = ['match_name', 'match_note', 'match_price', 'match_date']

  # Attributes
  # title             :string

  # match_name        :boolean
  # name              :string

  # match_note        :boolean
  # note              :string

  # match_price       :boolean
  # price_min         :integer
  # price_max         :integer

  # match_date        :boolean
  # start_at          :datetime
  # end_at            :datetime

  # timestamps

  before_validation { self.title = to_s }

  validates :title, presence: true
  validates :name, presence: true, if: -> { match_name? }
  validates :note, presence: true, if: -> { match_note? }

  validates :match_name, if: -> { match_note? || match_price? || match_date? }, presence: { message: 'required to apply additional matches' }

  validate(if: -> { match_price? }) do
    unless (price_min.present? || price_max.present?)
      self.errors.add(:price_min, 'at least one required')
      self.errors.add(:price_max, 'at least one required')
    end
  end

  validate(if: -> { match_date? }) do
    unless (start_at.present? || end_at.present?)
      self.errors.add(:start_at, 'at least one required')
      self.errors.add(:end_at, 'at least one required')
    end
  end

  # We want to validate category_id so the effective_select says "can't be blank"
  # But not enforce it when we're creating a new category
  validates :category_id, presence: true, unless: -> { category&.new_record? }
  validates :user, presence: true

  def match?(item)
    match = false

    if match_name?
      match ||= item.name.downcase.include?(name.downcase)
    end

    if match_note?
      match ||= item.note.to_s.downcase.include?(note.downcase)
    end

    if match_price?
      match ||= ((price_min || 0)..(price_max || 99999)).include?(item.price)
    end

    if match_date?
      match ||= ((start_at || Time.zone.local(2000, 0, 0))..(end_at || Time.zone.local(2050, 0, 0))).include?(item.date)
    end

    match
  end

  def to_s
    [
      ("name matches: #{name}" if match_name?),
      ("note matches: #{note}" if match_note?),
      ("price matches: #{price_min}..#{price_max}" if match_price?),
      ("date matches: #{date_min&.strftime('%F')}..#{date_max&.strftime('%F')}" if match_date?),
    ].join(', ')
  end

end
