class AccountYear
  attr_accessor :account, :year, :debits, :credits

  def initialize(account:, year:, debits: false, credits: false)
    @account = account
    @year = year
    @debits = debits
    @credits = credits
  end

  def collection
    @collection ||= (
      # All the groups
      categories = items.map { |item| item.category }.uniq
      monthly = items.group_by { |item| "#{item.category_id}_#{item.date.month}" }
      totally = items.group_by { |item| item.category_id }

      # For each category, category, months, total
      categories.inject({}) do |h, category|
        h[category.id] = (
          [category] + months.map do |month|
            monthly.fetch("#{category.id}_#{month.month}", [])
          end + [totally.fetch(category.id, [])]
        ); h
      end
    )
  end

  def totals
    @totals ||= (
      monthly = items.group_by { |item| Time.zone.local(year, item.date.month) }
      ['Total'] + months.map { |month| monthly.fetch(month, []) } + [items]
    )
  end

  def balances
    @balances ||= (
      monthly = items.group_by { |item| Time.zone.local(year, item.date.month) }
      months.map do |month|
        monthly.fetch(month, []).sort do |a, b|
          val = a.date <=> b.date
          val == 0 ? a.id <=> b.id : val
        end.last&.balance
      end
    )
  end

  def months
    @months ||= (1..12).map { |month| Time.zone.local(year, month) }
  end

  def debit
    true if @debits
  end

  def credit
    true if @credits
  end

  private

  def items
    @items ||= (
      items = account.items.deep.where(date: months.first.all_year).to_a

      # Items scoped by debits or credits
      items = items.select { |item| item.debit.present? } if @debits
      items = items.select { |item| item.credit.present? } if @credits

      items
    )
  end

end
