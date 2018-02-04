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
      categories.map do |category|
        [category] + months.map do |month|
          monthly.fetch("#{category.id}_#{month.month}", []).map { |item| item.amount }.sum
        end + [totally.fetch(category.id, []).map { |item| item.amount }.sum]
      end
    )
  end

  def totals
    @totals ||= (
      monthly = items.group_by { |item| item.date.month }

      ['Total'] + months.map do |month|
        monthly.fetch(month, []).map { |item| item.amount.sum }
      end + [items.map { |item| item.amount }.sum]
    )
  end

  def months
    @months ||= (1..12).map { |month| Time.zone.local(year, month) }
  end

  private

  def items
    @items ||= (
      items = account.items.includes(:category).where(date: months.first.all_year).to_a

      # Items scoped by debits or credits
      items = items.select { |item| item.debit.present? } if @debits
      items = items.select { |item| item.credit.present? } if @credits

      items
    )
  end



end
