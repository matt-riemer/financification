require 'csv'

class Import < ApplicationRecord
  belongs_to :account

  has_many :items
  accepts_nested_attributes_for :items

  # Attributes
  # content      :text
  # timestamps

  before_validation :build_items
  validates :account, presence: true

  validate do
    self.errors.add(:base, 'uhoh')
  end

  def to_s
    created_at&.strftime('%F') || 'New Import'
  end

  private

  # So this is going to parse each line from `content` and then find_or_initialize an item for each line
  # Try to guess the source
  # Any items where the source is not defined, we can do a create on
  def build_items
    begin
      CSV.parse(content.to_s) do |row|
        date, name, amount, note = row[0], row[1], row[2], row[3]

        date = Time.zone.parse(date)

        self.items.build(account: account, amount: amount, date: date, name: name, note: note)
      end
    rescue => e
      self.errors.add(:content, e.message)
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
# 2017-04-01,,RED ROBIN-WEST EDMONTON  EDMONTON,17.57
# 2017-04-15,JR EAST SHOPPING CENTER  SIBUYAKU,13.05
# 2017-04-20,PAYMENT - THANK YOU,65.55
