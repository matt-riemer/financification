class Import < ApplicationRecord
  belongs_to :account

  # Attributes
  # content      :text
  # timestamps

  validates :account, presence: true

  def to_s
    created_at&.strftime('%F') || 'New Import'
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
