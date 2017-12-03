# Basically a Tag
class Source < ApplicationRecord

  CATEGORIES = ['Debit', 'Credit']

  has_many :items

  # Attributes
  # name        :string
  # category    :string
  # timestamps

  validates :name, presence: true
  validates :category, presence: true

  def debit?
    category == 'Debit'
  end

  def credit?
    category == 'Credit'
  end

end
